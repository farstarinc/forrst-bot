# Configure Cinch
ForrstBot::Bot.configure do |c|
  c.nick     = 'forrst-bot'
  c.user     = 'forrst-bot'
  c.password = nil
  c.server   = 'irc.freenode.net'
  c.channels = ['#forrst-chat']
  c.verbose  = false

  # Plugin configuration
  c.plugins.prefix = /^\$/

  c.plugins.plugins = [
    Cinch::Plugins::Identify,
    Cinch::Plugins::UrbanDictionary,
    Cinch::Plugins::TwitterMention,
    Cinch::Plugins::Rehost,
    Cinch::Plugins::Script
  ]

  c.plugins.options[Cinch::Plugins::Identify] = {
    :username => 'forrst-bot',
    :password => nil,
    :type     => :nickserv 
  }

  c.plugins.options[Cinch::Plugins::Rehost] = {
    :api_key => nil
  }

  c.plugins.options[Cinch::Plugins::Script] = {
    :script => File.expand_path('../../script', __FILE__)
  }
end
