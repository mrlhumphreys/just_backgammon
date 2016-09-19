module JustBackgammon

  # = PiecesOnBarError
  #
  # A pieces on bar error with a message
  class PiecesOnBarError

    # A new instance of PiecesOnBarError.
    #
    # @option [String] message
    #   the message.
    #
    # ==== Example:
    #   # Instantiates a new PiecesOnBarError
    #   JustBackgammon::PiecesOnBarError.new("Custom Message")
    def initialize(message="There are still pieces on the bar.")
      @message = message
    end
  end
end