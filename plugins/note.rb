#:nodoc:
module Cinch
  #:nodoc:
  module Plugins
    ##
    # The Note plugin can be used to leave messages for other users when they're
    # not around. As soon as a user speaks in a channel the bot is active in teh
    # bot will send a private message to that user with all unread notes.
    #
    # Usage:
    #
    #     [TRIGGER]note [USERNAME] [NOTE]
    #
    # @author Yorick Peterse
    # @since  14-07-2011
    #
    class Note
      include Cinch::Plugin

      plugin 'note'
      help   'Allows users to leave notes for themselves or other users. ' \
        + 'Example: $note yorickpeterse Hello, world!'

      listen_to(:message)
      listen_to(:join, :method => :list)

      match(/note\s+([\w\-\{\\\_}<\]\[\^]+)\s+(.*)/)

      ##
      # Notifies a user that he/she has a number of unread notes as soon as that
      # particular user speaks in a channel.
      #
      # @author Yorick Peterse
      # @since  14-07-2011
      # @param  [Cinch::Message] message
      #
      def listen(message)
        user  = message.user.nick
        notes = ForrstBot::Model::Note.filter(:user => user).all

        if !notes.empty?
          User(user).send("You have #{notes.size} unread note(s):")

          notes.each do |note|
            User(user).send(
              "[#{note.created_at.strftime('%Y-%m-%d %H:%M')}] " \
                + "#{note.channel} <#{note.author}> #{note.note}"
            )
          end

          ForrstBot::Model::Note.filter(:user => user).destroy
        end
      end

      ##
      # Executes the plugin whenever a user wants to store a new note for
      # somebody.
      #
      # @author Yorick Peterse
      # @since  14-07-2011
      # @param  [Cinch::Message] message
      # @param  [String] receiver The nickname of the receiver.
      # @param  [String] note The note to store.
      #
      def execute(message, receiver, note)
        if receiver === ForrstBot::Bot.nick
          return message.reply('You can not store notes for me', true)
        end

        begin
          ForrstBot::Model::Note.create(
            :channel => message.channel.to_s,
            :user    => receiver,
            :author  => message.user.nick,
            :note    => note
          )

          message.reply('The note has been stored', true)
        rescue => e
          message.reply(e.message, true)
        end
      end

      ##
      # Tells the user how many notes he/she has.
      #
      # @author Yorick Peterse
      # @since  14-07-2011
      # @param  [Cinch::Message] message
      #
      def list(message)
        return if message.user.nick === ForrstBot::Bot.nick

        count = ForrstBot::Model::Note.filter(:user => message.user.nick).count

        if count > 0
          message.reply(
            "You have #{count} note(s), speak in a channel I'm active in and " \
              + "I'll send them to you.",
            true
          )
        end
      end
    end # Note
  end # Plugins
end # Cinch
