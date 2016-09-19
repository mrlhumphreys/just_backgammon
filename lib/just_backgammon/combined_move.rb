module JustBackgammon

  # = CombinedMove
  #
  # A combined move is a move where one piece moves multiple times.
  class CombinedMove
    extend Forwardable

    # A new instance of CombinedMove.
    #
    # @param [Array<Move>] legs
    #   The legs of the combined move.
    #
    # ==== Example:
    #   # Instantiates a new CombinedMove
    #   JustBackgammon::CombinedMove.new({
    #     legs: [move_a, move_b]
    #   })
    def initialize(legs:)
      @legs = legs
    end

    # @return [Array<Move>] the legs of the combined move.
    attr_reader :legs

    def_delegator :legs, :size

    # Does the combined move start from a point?
    #
    # @return [Boolean]
    def from_point?
      first_leg.instance_of?(JustBackgammon::Point) if first_leg
    end

    # Does the combined move start with an empty point?
    #
    # @return [Boolean]
    def empty?
      first_leg.empty? if first_leg
    end

    # Does the combined move have pieces owned by the opponent?
    #
    # @return [Boolean]
    def owned_by_opponent?(player_number)
      first_leg.owned_by_opponent?(player_number) if first_leg
    end

    private

    def first_leg # :nodoc:
      legs.first
    end
  end
end
