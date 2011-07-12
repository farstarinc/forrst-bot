#:nodoc:
module Cinch
  #:nodoc:
  module Plugins
    ##
    # Plugin that tells the bot to yell at somebody if he/she mentions another
    # user using Twitter style mentions (@username). This isn't Twitter, THIS IS
    # IRC!
    #
    # @author Yorick Peterse
    # @since  12-07-2011
    #
    class TwitterMention
      include Cinch::Plugin

      match(
        /@([\w\-\{\\\_}<\]\[\^]+)/, 
        :use_prefix => false, 
        :use_suffix => false
      )

      ##
      # Method that is executed for each message that matches the regular
      # expression set in the match() method.
      # 
      # @author Yorick Peterse
      # @since  12-07-2011
      # @param  [Cinch::Message]
      # @param  [String] matched_user The user that was mentioned.
      #
      def execute(message, matched_user)
        users = message.channel.users.map do |u|
          u[0].nick
        end

        if users.include?(matched_user)
          message.reply(
            'HEY! This isn\'t Twitter, IRC uses the following format for ' \
              + 'mentions: [USERNAME]: [MESSAGE]',
            true
          )
        end
      end
    end # TwitterMention
  end # Plugins
end # Cinch
