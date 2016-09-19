module JustBackgammon

  # = PointOwnershipError
  #
  # A point ownership error with a message
  class PointOwnershipError

    # A new instance of PointOwnershipError.
    #
    # @option [String] message
    #   the message.
    #
    # ==== Example:
    #   # Instantiates a new PointOwnershipError
    #   JustBackgammon::PointOwnershipError.new("Custom Message")
    def initialize(message="Point is not owned by player.")
      @message = message
    end
  end
end