require 'net/http'
require 'uri'

#:nodoc:
module Cinch
  #:nodoc:
  module Plugins
    ##
    # The Ping plugin allows you to check whether a website is down
    # for you only or for everyone else too.
    # The plugin is similar to downforeveryoneorjustme.com.
    # 
    # Usage:
    #
    #     [TRIGGER]ping [URL]
    #
    # Example:
    #
    #     $ping http://www.google.com/
    #
    # @author Abdelrahman Mahmoud
    # @since  23-07-2011
    #
    class Ping
      include Cinch::Plugin

      plugin 'ping'
      help   'Checks if the website is down or not. Example: $ping http://google.com/'

      match(/ping\s+(.+)/)

      ##
      # Executes the plugin.
      #
      # @author Abdelrahman Mahmoud
      # @since  23-07-2011
      # @param  [Cinch::Message] message
      # @param  [String] url The URL you want to ping.
      #
      def execute(message, url)
        # Parse the URL
        url = URI.parse(url)

        if url.host.nil?
          return message.reply('The specified URL is invalid', true)
        end

        begin
          Net::HTTP.start(url.host) do |http|
            http.get('/')
          end

          return message.reply(
            'It\'s just you, the website is up.', true
          )
        rescue => e
          return message.reply(
            'It\'s not just you, the website appears to be down.', true
          )
        end      
      end
    end # Ping
  end # Plugins
end # Cinch
