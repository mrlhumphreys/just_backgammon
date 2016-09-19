module JustBackgammon

  # = WrongDirectionError
  #
  # A wrong direction error with a message
  class WrongDirectionError

    # A new instance of WrongDirectionError.
    #
    # @option [String] message
    #   the message.
    #
    # ==== Example:
    #   # Instantiates a new WrongDirectionError
    #   JustBackgammon::WrongDirectionError.new("Custom Message")
    def initialize(message="A piece cannot move backwards.")
      @message = message
    end
  end
end