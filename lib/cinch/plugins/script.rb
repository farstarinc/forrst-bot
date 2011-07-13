#:nodoc:
module Cinch
  #:nodoc:
  module Plugins
    ##
    # Plugin that allows users to execute various scripts, regardless of the
    # language they're created in.
    #
    # ## Usage
    #
    #     [TRIGGER]script [SCRIPT] [PARAM]
    #
    # ## Example
    #
    #     $script hello.pl yorick
    #
    # This would result in a reply with the message "Hello, yorick".
    #
    # ## Options
    #
    # * script: the directory containing all the scripts. Note that all scripts
    #   in this directory can be called by a user.
    #
    # @author Yorick Peterse
    # @since  14-07-2011
    #
    class Script
      include Cinch::Plugin

      match(/script\s+(\S+)(.*)/)

      ##
      # Executes the plugin.
      #
      # @author Yorick Peterse
      # @since  13-07-2011
      # @param  [Cinch::Message]
      # @param  [String] script The filename of the script to call.
      # @param  [String] params A whitespace separated string containing all the
      # parameters to pass to the script.
      #
      def execute(message, script, params)
        script = File.join(config[:script], File.basename(script))
        
        if File.exist?(script)
          message.reply(`#{script} #{params}`, true)
        else
          message.reply('The specified script does not exist', true)
        end
      end
    end
  end # Plugins
end # Cinch
