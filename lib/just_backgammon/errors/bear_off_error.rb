module JustBackgammon

  # = BearOffError
  #
  # A bear off error with a message
  class BearOffError

    # A new instance of BearOffError.
    #
    # @option [String] message
    #   the message.
    #
    # ==== Example:
    #   # Instantiates a new BearOffError
    #   JustBackgammon::BearOffError.new("Custom Message")
    def initialize(message="Cannot bear off while pieces are not home.")
      @message = message
    end
  end
end