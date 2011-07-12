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
    #     +rehost https://encrypted.google.com/images/logos/ssl_ps_logo.png
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

      match(/rehost (.+)/)

      ##
      # Executes the plugin.
      #
      # @author Yorick Peterse
      # @since  12-07-2011
      # @param  [Cinch::Message]
      # @param  [String] image The URL to the image that has to be
      # re-hosted.
      #
      def execute(message, image)
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
    end
  end # Plugins
end # Cinch
