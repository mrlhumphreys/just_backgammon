module JustBackgammon

  # = EmptyBarError
  #
  # An empty bar error with a message
  class EmptyBarError

    # A new instance of EmptyBarError.
    #
    # @option [String] message
    #   the message.
    #
    # ==== Example:
    #   # Instantiates a new EmptyBarError
    #   JustBackgammon::EmptyBarError.new("Custom Message")
    def initialize(message="No pieces owned by player on bar.")
      @message = message
    end
  end
end