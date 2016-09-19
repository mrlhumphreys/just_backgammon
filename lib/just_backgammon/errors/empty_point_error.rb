module JustBackgammon

  # = EmptyPointError
  #
  # An empty point error with a message
  class EmptyPointError

    # A new instance of EmptyPointError.
    #
    # @option [String] message
    #   the message.
    #
    # ==== Example:
    #   # Instantiates a new EmptyPointError
    #   JustBackgammon::EmptyPointError.new("Custom Message")
    def initialize(message="Point is empty.")
      @message = message
    end
  end
end