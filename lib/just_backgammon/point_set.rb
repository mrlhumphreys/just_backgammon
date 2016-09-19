require 'forwardable'
require 'just_backgammon/common'
require 'just_backgammon/point'

module JustBackgammon

  # = PointSet
  #
  # A collection of points.
  class PointSet
    extend Common
    extend Forwardable

    # A new instance of Bar.
    #
    # @param [Array<Hash>] points
    #   All the points in the set.
    #
    # ==== Example:
    #   # Instantiates a new PointSet
    #   JustBackgammon::PointSet.new({
    #     points: [point_a, point_b]
    #   })
    def initialize(points:)
      @points = Point.load(points)
    end

    # @return [Array<Point>] all the points in the set
    attr_reader :points

    def_delegator :points, :map
    def_delegator :points, :any?
    def_delegator :points, :size

    # Finds a point with the matching number.
    #
    # @return [Point]
    def find_by_number(number)
      points.find { |p| p.number == number }
    end

    # Finds all points with pieces that are not yet home for the specified player.
    #
    # @return [PointSet]
    def not_home(player_number)
      not_home_points = points.select { |p| p.owned_by_player?(player_number) && !p.home?(player_number) }
      self.class.new(points: not_home_points)
    end

    # Checks if any pieces are not yet home for the specified player.
    #
    # @return [Boolean]
    def some_pieces_not_home?(player_number)
      not_home(player_number).any?
    end

    # Finds all points owned by the specified player.
    #
    # @return [PointSet]
    def owned_by_player(player_number)
      owned = @points.select { |p| p.owned_by_player?(player_number) }
      self.class.new(points: owned)
    end

    # Finds all destinations points from a point with a dice roll for the specified player.
    #
    # @return [PointSet]
    def destinations(from, dice, player_number)
      in_range = dice.map { |d| destination(from, d, player_number) }.compact
      possible = in_range.select { |p| p.empty? || p.owned_by_player?(player_number) || p.blot? }
      self.class.new(points: possible)
    end

    # A hashed serialized representation of the bar.
    #
    # @return [Hash]
    def as_json
      points.map(&:as_json)
    end

    private

    def destination(from, die, player_number)  # :nodoc:
      case player_number
      when 1
        from_number = from.instance_of?(Bar) ? 0 : from.number
        find_by_number(from_number + die.number)
      when 2
        from_number = from.instance_of?(Bar) ? 25 : from.number
        find_by_number(from_number - die.number)
      else
        nil
      end
    end
  end
end