module JustBackgammon

  # = NotPlayersTurnError
  #
  # A not player's turn error with a message
  class NotPlayersTurnError

    # A new instance of NotPlayersTurnError.
    #
    # @option [String] message
    #   the message.
    #
    # ==== Example:
    #   # Instantiates a new NotPlayersTurnError
    #   JustBackgammon::NotPlayersTurnError.new("Custom Message")
    def initialize(message="It is not the player's turn yet.")
      @message = message
    end
  end
end