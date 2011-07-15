#:nodoc:
module ForrstBot
  #:nodoc:
  module Model
    ##
    # Model for the notes plugin.
    #
    # @author Yorick Peterse
    # @since  14-07-2011
    #
    class Note < Sequel::Model
      plugin :timestamps, :created => :created_at

      ##
      # Validates the model.
      #
      # @author Yorick Peterse
      # @since  14-07-2011
      #
      def validate
        validates_presence([:channel, :user, :author, :note])
      end
    end # Note
  end # Model
end # ForrstBot
