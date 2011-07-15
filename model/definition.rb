#:nodoc:
module ForrstBot
  #:nodoc:
  module Model
    ##
    # Model for the definition plugin.
    #
    # @author Yorick Peterse
    # @since  15-07-2011
    #
    class Definition < Sequel::Model
      plugin :timestamps, :created => :created_at

      ##
      # Validates the model.
      #
      # @author Yorick Peterse
      # @since  15-07-2011
      #
      def validate
        validates_presence([:name, :value, :author, :channel])
      end
    end # Definition
  end # Model
end # ForrstBot
