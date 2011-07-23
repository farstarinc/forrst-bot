require 'net/http'
require 'uri'

#:nodoc:
module Cinch
  #:nodoc:
  module Plugins
    ##
    # The Ping plugin allows you to check whether a website is down for you only
    # or for everyone else too.  The plugin is similar to
    # downforeveryoneorjustme.com.
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
      include ForrstBot::Helper::Help

      plugin 'ping'
      help   "Checks if the website is down or not." \
        + "\nExample: $ping http://google.com/"

      match(/(ping|up)\s+(.+)/)
      match(/(ping|up)$/, :method => :show_help)

      ##
      # Executes the plugin.
      #
      # @author Abdelrahman Mahmoud
      # @since  23-07-2011
      # @param  [Cinch::Message] message
      # @param  [String] cmd The cmd that was called, either "ping" or "up".
      # @param  [String] url The URL you want to ping.
      #
      def execute(message, cmd, url)
        # URI.parse always requires a scheme
        url = 'http://' + url if !url.match(/^http/)

        begin
          url = URI.parse(url)
        rescue => e
          return message.reply("The URL is invalid: #{e.message}", true)
        end

        return message.reply('The URL is invalid', true) if url.host.nil?

        begin
          duration = Time.new.to_f

          Timeout.timeout(5) do
            Net::HTTP.start(url.host) do |http|
              http.get('/')
            end
          end

          duration = ((Time.new.to_f - duration) * 100).round(2)

          if duration >= 1000
            duration = "#{duration} s"
          else
            duration = "#{duration} ms"
          end

          return message.reply(
            "It's just you, the website is up. Response time: #{duration}",
            true
          )
        rescue => e
          return message.reply(
            "It's not just you, the website appears to be down: #{e.message}",
            true
          )
        end
      end
    end # Ping
  end # Plugins
end # Cinch
