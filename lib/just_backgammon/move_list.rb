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
      combined_data = moves.inject([]) do |combined, move|
        matching_move = combined.find_index { |combined_move| combined_move.last.number == move.from.number }
        if matching_move
          combined[matching_move].push(move.to)
        else
          combined.push([move.from, move.to])
        end

        combined
      end

      combined_data.map { |legs| JustBackgammon::CombinedMove.new(legs: legs) }
    end

    # For any of the combined moves, checks if there is one with more two legs or more.
    #
    # @return [Boolean]
    def piece_moves_multiple_times?
      combined_moves.any?(&:multi_leg?)
    end

    # Checks if any move have no points.
    #
    # @return [Boolean]
    def any_missing_point?
      moves.any?(&:missing_point?)
    end

    # Checks if any move have empty points.
    #
    # @return [Boolean]
    def any_point_empty?
      combined_moves.any? { |move| move.from_point? && move.empty? }
    end

    # Checks if any move have is owned by the opponent.
    #
    # @return [Boolean]
    def any_point_owned_by_opponent?(current_player_number)
      combined_moves.any? { |move| move.from_point? && move.owned_by_opponent?(current_player_number) }
    end

    # Checks if any move is from an empty bar.
    #
    # @return [Boolean]
    def any_bar_empty_for_player?(current_player_number)
      moves.any? { |move| move.from_bar? && move.empty_for_player?(current_player_number) }
    end

    # Checks if any move is blocked from moving.
    #
    # @return [Boolean]
    def any_blocked?(current_player_number)
      moves.any? { |move| move.blocked?(current_player_number) }
    end

    # Checks if any move is going the wrong direction.
    #
    # @return [Boolean]
    def any_wrong_direction?(current_player_number)
      moves.any? { |move| move.wrong_direction?(current_player_number) }
    end

    # Checks if any move is bearing off.
    #
    # @return [Boolean]
    def any_bear_off?
      moves.any?(&:bear_off?)
    end

    # Checks if all moves are from the bar.
    #
    # @return [Boolean]
    def all_moves_from_bar?
      moves.all?(&:from_bar?)
    end

    # The number of moves from the bar.
    #
    # @return [Fixnum]
    def number_of_moves_from_bar
      moves.select(&:from_bar?).size
    end

    # How far each of the moves go.
    #
    # @return [Array<Fixnum>]
    def absolute_distances(current_player_number)
      moves.map { |move| move.absolute_distance_for_player(current_player_number) }
    end

    # Checks if there are still pieces on the bar.
    #
    # @return [Boolean]
    def pieces_still_on_bar?(current_player_number, points, dice, bar)
      !all_moves_from_bar? && \
      number_of_moves_from_bar != bar.number_of_pieces_owned_by_player(current_player_number) && \
      points.destinations(bar, dice, current_player_number).size >= number_of_moves_from_bar
    end

    # Checks if they player cannot bear off.
    #
    # @return [Boolean]
    def cannot_bear_off?(current_player_number, points)
      any_bear_off? && !(points.not_home(current_player_number).map(&:number) - map { |move| move.from.number }).empty?
    end

    # Checks if any of the moves don't match the dice rolls
    #
    # @return [Boolean]
    def dice_mismatch?(current_player_number, points, dice, bar)
      current_player_has_moves?(current_player_number, points, dice, bar) && moves_mismatch_dice?(current_player_number, dice)
    end

    private

    def moves_mismatch_dice?(current_player_number, dice) # :nodoc:
      unallocated = dice.numbers.sort
      allocated = []

      moves.each do |move|
        move_distance = move.absolute_distance_for_player(current_player_number)

        index = unallocated.index do |die_number|
          if move.bear_off?
            die_number >= move_distance
          else
            die_number == move_distance
          end
        end

        if index
          die = unallocated.delete_at(index)
          allocated.push(die)
        end
      end
      allocated.size != moves.size
    end

    def current_player_has_moves?(current_player_number, points, dice, bar)  # :nodoc:
      if bar.any_pieces_for_player?(current_player_number)
        points.destinations(bar, dice, current_player_number).any?
      else
        points.owned_by_player(current_player_number).any? do |point|
          points.destinations(point, dice, current_player_number).any?
        end
      end
    end
  end
end