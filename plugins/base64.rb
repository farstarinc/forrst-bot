#:nodoc:
module Cinch
  #:nodoc:
  module Plugins
    ##
    # Plugin that will automatically kick a certain user if he/she pastes base64
    # image URLs into the chat.
    #
    # @author Yorick Peterse
    # @since  14-07-2011
    #
    class Base64
      include Cinch::Plugin

      plugin 'base64'
      help 'Kicks a user if he/she pastes a Base64 encoded string into the chat'

      match(
        /^data:\w+\/\w+;base64/, 
        :use_prefix => false, 
        :use_suffix => false
      )

      ##
      # Executes the plugin.
      #
      # @author Yorick Peterse
      # @since  14-07-2011
      # @param  [Cinch::Message] message
      #
      def execute(message)
        message.channel.kick(message.user.nick, 'Base64 does not work in IRC')
      end
    end # Base64
  end # Plugins
end # Cinch
