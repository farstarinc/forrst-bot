#:nodoc:
module Cinch
  #:nodoc:
  module Plugins
    ##
    # Plugin that's used to keep a close eye on the users and ensure they don't
    # act like retards.
    #
    # @author Yorick Peterse
    # @since  15-07-2011
    #
    class BadBehaviour
      include Cinch::Plugin

      plugin 'bad_behaviour'
      help   'Keeps a close eye on all the users to ensure they ' \
        + 'don\'t act like retards.'

      match(
        /^data:\w+\/\w+;base64/, 
        :use_prefix => false, 
        :use_suffix => false,
        :method     => :base64
      )

      match(
        /@([\w\-\{\\\_}<\]\[\^]+)/, 
        :use_prefix => false, 
        :use_suffix => false,
        :method     => :twitter_mention
      )

      ##
      # Kicks a user whenever they paste Base64 encoded objects into the chat.
      #
      # @author Yorick Peterse
      # @since  14-07-2011
      # @param  [Cinch::Message] message
      #
      def base64(message)
        message.channel.kick(message.user.nick, 'Base64 does not work in IRC')
      end

      ##
      # Yells at a user for using @username style mentions in a channel.
      # 
      # @author Yorick Peterse
      # @since  12-07-2011
      # @param  [Cinch::Message] message
      # @param  [String] matched_user The user that was mentioned.
      #
      def twitter_mention(message, matched_user)
        users = message.channel.users.map { |u| u[0].nick }

        if users.include?(matched_user)
          message.reply(
            'HEY! This isn\'t Twitter, IRC uses the following format for ' \
              + 'mentions: [USERNAME]: [MESSAGE]',
            true
          )
        end
      end
    end # BadBehaviour
  end # Plugins
end # Cinch
