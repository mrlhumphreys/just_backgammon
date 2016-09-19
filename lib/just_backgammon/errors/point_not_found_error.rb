module JustBackgammon

  # = PointNotFoundError
  #
  # A point not found error with a message
  class PointNotFoundError

    # A new instance of PointNotFoundError.
    #
    # @option [String] message
    #   the message.
    #
    # ==== Example:
    #   # Instantiates a new PointNotFoundError
    #   JustBackgammon::PointNotFoundError.new("Custom Message")
    def initialize(message="Point cannot be found.")
      @message = message
    end
  end
end