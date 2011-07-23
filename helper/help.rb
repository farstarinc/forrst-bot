module ForrstBot
  module Helper
    ##
    # Helper module for help related actions.
    #
    # @author Yorick Peterse
    # @since  23-07-2011
    #
    module Help
      ##
      # Sends a message to the channel containing the help message.
      #
      # @author Yorick Peterse
      # @since  23-07-2011
      # @param  [Cinch::Message] message
      #
      def show_help(message)
        message.reply(
          self.class.instance_variable_get(:@__cinch_help_message)
        )
      end
    end # Help
  end # Helper
end # ForrstBot
