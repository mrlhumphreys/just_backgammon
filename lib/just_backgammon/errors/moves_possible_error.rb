module JustBackgammon

  # = MovesPossibleError
  #
  # A moves possible error with a message
  class MovesPossibleError

    # A new instance of MovesPossibleError.
    #
    # @option [String] message
    #   the message.
    #
    # ==== Example:
    #   # Instantiates a new MovesPossibleError
    #   JustBackgammon::MovesPossibleError.new("Custom Message")
    def initialize(message="Moves are still possible.")
      @message = message
    end
  end
end