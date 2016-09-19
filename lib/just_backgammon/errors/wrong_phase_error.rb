module JustBackgammon

  # = WrongPhaseError
  #
  # A wrong phase error with a message
  class WrongPhaseError

    # A new instance of WrongPhaseError.
    #
    # @option [String] message
    #   the message.
    #
    # ==== Example:
    #   # Instantiates a new WrongPhaseError
    #   JustBackgammon::WrongPhaseError.new("Custom Message")
    def initialize(message="It is the wrong phase.")
      @message = message
    end
  end
end