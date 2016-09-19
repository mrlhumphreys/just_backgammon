module JustBackgammon

  # = DiceMismatchError
  #
  # A dice mismatch error with a message
  class DiceMismatchError

    # A new instance of DiceMismatchError.
    #
    # @option [String] message
    #   the message.
    #
    # ==== Example:
    #   # Instantiates a new DiceMismatchError
    #   JustBackgammon::DiceMismatchError.new("Custom Message")
    def initialize(message="Move does not match dice rolls.")
      @message = message
    end
  end
end