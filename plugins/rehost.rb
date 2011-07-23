require 'net/http'
require 'json'
require 'uri'

#:nodoc:
module Cinch
  #:nodoc:
  module Plugins
    ##
    # The Rehost plugin allows users to specify a URL to an image which will be
    # downloaded by the bot and uploaded to imgur. This allows users to bypass
    # their corporate Firewalls (materialdesigner in particular) as Imgur
    # doesn't seem to be blocked as often as other websites.
    #
    # Usage:
    #
    #     [TRIGGER]rehost [URL]
    #
    # Example:
    #
    #     $rehost https://encrypted.google.com/images/logos/ssl_ps_logo.png
    #
    # ## Options
    #
    # * api_key: the API key for the Imgur API, this option is required in order
    #   to upload images.
    #
    # @author Yorick Peterse
    # @since  12-07-2011
    #
    class Rehost
      include Cinch::Plugin

      plugin 'rehost'
      help   'Rehosts an image on Imgur. Example: $rehost http://cl.ly/8Qmm'

      match(/rehost\s+(.+)/)
      match(/rehost$/, :method => :show_help)

      ##
      # Executes the plugin.
      #
      # @author Yorick Peterse
      # @since  12-07-2011
      # @param  [Cinch::Message] message
      # @param  [String] image The URL to the image that has to be
      # re-hosted.
      #
      def execute(message, image)
        # If the page is an HTML page we'll have to extract the image URL. The
        # first <img> tag that's found is used.
        image = URI.parse(image)

        if image.host.nil?
          return message.reply('The specified URL is invalid', true)
        end

        response = Net::HTTP.start(image.host) do |http|
          http.get(image.path)
        end

        if response.class == Net::HTTPOK and response.content_type === 'text/html'
          response = Nokogiri::HTML(response.body)
          image    = response.css('img')[0].attr('src')

          if image.nil?
            return message.reply(
              'Failed to extract the image from the HTML page', true
            )
          end
        end

        # Get the actual image URL as they're sometimes redirected. Yes, I'm
        # looking at you Cloudapp.
        image = get_real_url(image.to_s)

        # POST that bad boy
        response = Net::HTTP.post_form(
          URI.parse('http://api.imgur.com/2/upload.json'),
          :key   => config[:api_key],
          :image => image,
          :type  => 'url'
        )

        if response.class != Net::HTTPOK
          return message.reply('Failed to upload the image to Imgur', true)
        end

        begin
          response = JSON.load(response.body)
        rescue
          return message.reply('Failed to decode the JSON response', true)
        end

        # Try to get the URL to the new image
        begin
          image = response['upload']['links']['original']
        rescue
          image = nil
        end

        if image
          return message.reply("Here's the rehosted image: #{image}", true)
        else
          return message.reply(
            'Failed to extract the image from the JSON response, ' \
              + 'make sure the URL points to an actual image',
            true
          )
        end
      end

      ##
      # Given a URL this method will keep following redirects until it hits the
      # limit. Once the limit has been reached the final URL is returned.
      #
      # @author Yorick Peterse
      # @since  13-07-2011
      # @param  [String] url The URL to open.
      # @param  [Fixnum] limit The amount of redirects to follow.
      # @return [String]
      #
      def get_real_url(url, limit = 10)
        followed = 0

        while followed < limit do
          url      = URI.parse(url)
          response = Net::HTTP.start(url.host) do |http|
            http.get(url.path)
          end

          if response['location']
            url       = response['location']
            followed += 1
          else
            break
          end
        end

        return url.to_s
      end
    end # Rehost
  end # Plugins
end # Cinch
