require 'cinch'
require 'sequel'
require 'nokogiri'

# Load all third-party plugins
require 'cinch/plugins/identify'
require 'cinch/plugins/urbandictionary'

# Load all official plugins
Dir.glob(File.expand_path('../plugins/*.rb', __FILE__)).each do |f|
  require(f)
end

# Load all the required Sequel extensions/plugins
Sequel.extension(:migration)
Sequel::Model.plugin(:validation_helpers)

##
# ForrstBot (known as "forrst-bot" on IRC) is a bot written for the Forrst
# channel #forrst-chat.
#
# @author Yorick Peterse
# @since  12-07-2011
#
module ForrstBot
  ##
  # Instance of Cinch::Bot.
  #
  # @author Yorick Peterse
  # @since  12-07-2011
  #
  Bot = Cinch::Bot.new

  class << self
    ##
    # The Sequel connection to use.
    #
    # @author Yorick Peterse
    # @since  12-07-2011
    #
    attr_accessor :database

    ##
    # Starts the bot.
    #
    # @author Yorick Peterse
    # @since  12-07-2011
    #
    def start
      # Ensure we're connected to a database
      if @database.nil?
        $stderr.puts('No database connection has been set')
        exit
      end
      
      # Load all the models after the database connection has been established.
      Dir.glob(
        File.expand_path('../model/*.rb', __FILE__)
      ).each do |f|
        require(f)
      end

      # Trap the signals
      ['TERM', 'INT', 'QUIT'].each do |signal|
        Signal.trap(signal) do
          Bot.quit
          @database.disconnect
        end
      end
      
      # Start the bot
      Bot.start
    end
  end # class << self
end # ForrstBot
