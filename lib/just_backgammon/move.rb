require 'forwardable'

module JustBackgammon

  # = Move
  #
  # A move from a point to a point.
  class Move
    extend Forwardable

    # A new instance of Move.
    #
    # @param [Point] from
    #   The point where the move starts.
    #
    # @param [Point] to
    #   The point where the move ends.
    #
    # ==== Example:
    #   # Instantiates a new Bar
    #   JustBackgammon::Move.new({from: point_a, to: point_b})
    def initialize(from: , to:)
      @from = from
      @to = to
    end

    # @return [Point] the point where the move starts
    attr_reader :from

    # @return [Point] the point where the move ends
    attr_reader :to

    def_delegator :from, :empty_for_player?

    # The distance of the move for the specified player.
    #
    # @return [Fixnum]
    def distance_for_player(player_number)
      case player_number
      when 1
        from_number = from.instance_of?(Bar) ? 0 : from.number
        to_number = to.instance_of?(OffBoard) ? 25 : to.number
        to_number - from_number
      when 2
        from_number = from.instance_of?(Bar) ? 25 : from.number
        to_number = to.instance_of?(OffBoard) ? 0 : to.number
        to_number - from_number
      else
        0
      end
    end

    # The absolute distance of the move for the specified player.
    #
    # @return [Fixnum]
    def absolute_distance_for_player(player_number)
      distance_for_player(player_number).abs
    end

    # Checks if the move is in the wrong direction for the specified player.
    #
    # @return [Boolean]
    def wrong_direction?(player_number)
      case player_number
      when 1
        distance_for_player(player_number) < 0
      when 2
        distance_for_player(player_number) > 0
      else
        true
      end
    end

    # Checks if the move is blocked.
    #
    # @return [Boolean]
    def blocked?(player_number)
      case to
      when OffBoard
        false
      else
        to.owned_by_opponent?(player_number) && to.blocked?
      end
    end

    # Checks if the move is missing points.
    #
    # @return [Boolean]
    def missing_point?
      from.nil? || to.nil?
    end

    # Checks if the move is from the bar.
    #
    # @return [Boolean]
    def from_bar?
      from.instance_of?(JustBackgammon::Bar)
    end

    # Checks if the move is to a point.
    #
    # @return [Boolean]
    def to_point?
      to.instance_of?(JustBackgammon::Point)
    end

    # Checks if the move is bearing off.
    #
    # @return [Boolean]
    def bear_off?
      to.instance_of?(JustBackgammon::OffBoard)
    end
  end
end