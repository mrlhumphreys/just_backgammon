module JustBackgammon

  # = BlockedError
  #
  # A blocked error with a message
  class BlockedError

    # A new instance of BlockedError.
    #
    # @option [String] message
    #   the message.
    #
    # ==== Example:
    #   # Instantiates a new BlockedError
    #   JustBackgammon::BlockedError.new("Custom Message")
    def initialize(message="Point blocked by opponent.")
      @message = message
    end
  end
end