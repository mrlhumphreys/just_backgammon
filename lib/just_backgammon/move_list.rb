require 'forwardable'
require 'just_backgammon/combined_move'

module JustBackgammon

  # = MoveList
  #
  # A list of moves.
  class MoveList
    extend Forwardable

    # A new instance of MoveList.
    #
    # @param [Array<Move>] moves
    #   All the moves.
    #
    # ==== Example:
    #   # Instantiates a new MoveList
    #   JustBackgammon::MoveList.new([move_a, move_b])
    def initialize(moves:)
      @moves = moves
    end

    # @return [Array<Move>] all the moves
    attr_reader :moves

    def_delegator :moves, :each
    def_delegator :moves, :map

    # Combines moves if there are any that start where another ends.
    #
    # @return [Array<CombinedMove>]
    def combined_moves
      combined_data = moves.inject([]) do |combined, m|
        matching_move = combined.find_index { |c| c.last.number == m.from.number }
        if matching_move
          combined[matching_move].push(m.to)
        else
          combined.push([m.from, m.to])
        end

        combined
      end

      combined_data.map { |legs| JustBackgammon::CombinedMove.new(legs: legs) }
    end

    # For any of the combined moves, checks if there is one with more two legs or more.
    #
    # @return [Boolean]
    def piece_moves_multiple_times?
      combined_moves.any? { |c| c.size > 2 }
    end

    # Checks if any move have no points.
    #
    # @return [Boolean]
    def any_missing_point?
      moves.any? { |m| m.missing_point? }
    end

    # Checks if any move have empty points.
    #
    # @return [Boolean]
    def any_point_empty?
      combined_moves.any? { |m| m.from_point? && m.empty? }
    end

    # Checks if any move have is owned by the opponent.
    #
    # @return [Boolean]
    def any_point_owned_by_opponent?(current_player_number)
      combined_moves.any? { |m| m.from_point? && m.owned_by_opponent?(current_player_number) }
    end

    # Checks if any move is from an empty bar.
    #
    # @return [Boolean]
    def any_bar_empty_for_player?(current_player_number)
      moves.any? { |m| m.from_bar? && m.empty_for_player?(current_player_number) }
    end

    # Checks if any move is blocked from moving.
    #
    # @return [Boolean]
    def any_blocked?(current_player_number)
      moves.any? { |m| m.blocked?(current_player_number) }
    end

    # Checks if any move is going the wrong direction.
    #
    # @return [Boolean]
    def any_wrong_direction?(current_player_number)
      moves.any? { |m| m.wrong_direction?(current_player_number) }
    end

    # Checks if any move is bearing off.
    #
    # @return [Boolean]
    def any_bear_off?
      moves.any? { |m| m.bear_off? }
    end

    # Checks if all moves are from the bar.
    #
    # @return [Boolean]
    def all_moves_from_bar?
      moves.all? { |m| m.from_bar? }
    end

    # The number of moves from the bar.
    #
    # @return [Fixnum]
    def number_of_moves_from_bar
      moves.select { |m| m.from_bar? }.size
    end

    # How far each of the moves go.
    #
    # @return [Array<Fixnum>]
    def absolute_distances(current_player_number)
      moves.map { |m| m.absolute_distance_for_player(current_player_number) }
    end

    # Checks if any of the moves don't match the dice rolls
    #
    # @return [Boolean]
    def dice_mismatch?(current_player_number, dice)
      unallocated = dice.numbers
      allocated = []

      moves.each do |m|
        move_distance = m.absolute_distance_for_player(current_player_number)

        index = unallocated.index do |d|
          if m.bear_off?
            d >= move_distance
          else
            d == move_distance
          end
        end

        if index
          die = unallocated.delete_at(index)
          allocated.push(die)
        end
      end

      allocated.size != moves.size
    end
  end
end