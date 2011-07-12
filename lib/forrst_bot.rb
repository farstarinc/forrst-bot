require 'cinch'
require 'sequel'

# Load all Cinch plugins
require 'cinch/plugins/identify'
require 'cinch/plugins/urbandictionary'

##
# ForrstBot (known as "forrst-bot" on IRC) is a bot written for the Forrst
# channel #forrst-chat.
#
# @author Yorick Peterse
# @since  12-07-2011
#
module ForrstBot
  ##
  # Hash containing various configuration options for the bot. This hash acts as
  # a "middleware" for the Cinch configuration so it can be stored in an
  # external file.
  #
  # @author Yorick Peterse
  # @since  12-07-2011
  #
  Options = {
    :nick      => 'forrst-bot',
    :user      => 'forrst-bot',
    :password  => nil,
    :server    => 'irc.freenode.net',
    :channels  => ['#forrst-chat'],
    :verbose   => false,
    :daemonize => false
  }

  class << self
    ##
    # The Sequel connection to use.
    #
    # @author Yorick Peterse
    # @since  12-07-2011
    #
    attr_accessor :database

    ##
    # Instance of Cinch as returned by Cinch::Bot.
    #
    # @author Yorick Peterse
    # @since  12-07-2011
    #
    attr_accessor :cinch

    ##
    # Starts the bot.
    #
    # @author Yorick Peterse
    # @since  12-07-2011
    #
    def start
      daemonize = Options.delete(:daemonize)

      # Ensure we're connected to a database
      if @database.nil?
        $stderr.puts('No database connection has been set')
        exit
      end

      # Configure the bot
      @cinch = Cinch::Bot.new do
        configure do |c|
          Options.each do |k, v|
            c.send("#{k}=", v) if c.respond_to?(k)
          end

          # Load all the plugins
          c.plugins.plugins = [
            Cinch::Plugins::Identify,
            Cinch::Plugins::UrbanDictionary
          ]

          # Configure the plugins
          c.plugins.options[Cinch::Plugins::Identify] = {
            :username => Options[:user],
            :password => Options[:password],
            :type     => :nickserv 
          }
        end
      end

      # Trap the signals
      ['TERM', 'INT', 'QUIT'].each do |signal|
        Signal.trap(signal) do
          @cinch.quit
          @database.disconnect
        end
      end
      
      # Start the bot
      Process.daemon(true) if daemonize
      @cinch.start
    end
  end # class << self
end # ForrstBot
