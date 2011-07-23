#:nodoc:
module Cinch
  #:nodoc:
  module Plugins
    ##
    # The definition plugin can be used to store small snippets of data, such as
    # a URL to a funny cat picture, in the bot's SQL database. These snippets
    # can be managed by all users.
    #
    # Usage:
    #
    #     [TRIGGER]def [NAME] [VALUE]
    #
    # Note that If the name contains whitespace characters it should be wrapped
    # in quotes.
    #
    # @author Yorick Peterse
    # @since  15-07-2011
    #
    class Definition
      include Cinch::Plugin
      include ForrstBot::Helper::Help

      plugin 'def'
      help   'Stores a "key/value" pair in the database and allows users to ' \
        + 'retrieve them at a later time. Whitespace in the keys is allowed.' \
        + "\nExample: $def \"tcy radio\" http://mixlr.com/tcyradio/live"

      match(/def\s+(.*)/)
      match(/def$/  , :method => :show_help)
      match(/\?(.*)/, :method => :retrieve)

      ##
      # Retrieves the given definition if it exists.
      #
      # @author Yorick Peterse
      # @since  23-07-2011
      # @param  [Cinch::Message] message
      # @param  [String] definition The definition to retrieve.
      #
      def retrieve(message, definition)
        definition = definition.strip
        existing   = ForrstBot::Model::Definition[
          :name    => definition,
          :channel => message.channel.to_s
        ]

        if existing
          return message.reply(existing.value, true)
        else
          return message.reply(
            "The definition \"#{definition}\" does not exist",
            true
          )
        end
      end

      ##
      # Stores a new definition in the database. The names of definitions can
      # include whitespace but only if the name has been quoted. This means that
      # the following is perfectly valid:
      #
      #     $def "tcy radio" http://mixlr.com/tcyradio/live
      #
      # The following is not and will result in the name "tcy" with a value of
      # "radio":
      #
      #     $def tcy radio http://mixlr.com/tcyradio/live
      #
      # @author Yorick Peterse
      # @since  15-07-2011
      # @param  [Cinch::Message] message
      # @param  [String] definition The name and value of the definition.
      #
      def execute(message, definition)
        definition = definition.strip
        quote      = /'|"/
        name       = nil
        value      = nil

        if definition =~ quote
          # Write the definition name into a buffer. Once the definition name
          # has been extracted all the content in the buffer will be removed
          # from the "definition" variable, the rest is used as the value.
          buffer = ''
          write  = false

          definition.chars.each do |char|
            # Determine if the data should be buffered
            if char =~ quote
              # Reached the end of the name, bail out
              if write === true
                buffer += char
                break
              # Start writing to the buffer
              else
                write = true
              end
            end

            buffer += char if write === true
          end

          # Now that we have the name (including quotes) we can easily get the
          # value.
          name               = buffer.gsub(quote, '').strip
          definition[buffer] = ''
          value              = definition.strip
        else
          # Easy, the definition is in the format of [name][whitespace][value]
          definition = definition.split(/\s/)
          name       = definition.delete_at(0).strip
          value      = definition.join(' ') unless definition.empty?
        end

        # Store the definition. Any existing definitions will be overwritten.
        existing = ForrstBot::Model::Definition[
          :name    => name,
          :channel => message.channel.to_s
        ]

        if existing
          existing.destroy
          message.reply(
            "The definition \"#{name}\" already exists and will be overwritten",
            true
          )
        end

        begin
          ForrstBot::Model::Definition.create(
            :name    => name,
            :value   => value,
            :author  => message.user.nick,
            :channel => message.channel.to_s
          )

          message.reply('The definition has been added', true) if !existing
        rescue => e
          message.reply("Failed to add the definition: #{e.inspect}", true)
        end
      end
    end # Definition
  end # Plugins
end # Cinch
