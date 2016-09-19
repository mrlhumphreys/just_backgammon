require 'just_backgammon/dice_set'
require 'just_backgammon/bar'
require 'just_backgammon/point_set'
require 'just_backgammon/off_board'
require 'just_backgammon/move'
require 'just_backgammon/move_list'

require 'just_backgammon/errors/not_players_turn_error'
require 'just_backgammon/errors/wrong_phase_error'
require 'just_backgammon/errors/point_not_found_error'
require 'just_backgammon/errors/empty_bar_error'
require 'just_backgammon/errors/empty_point_error'
require 'just_backgammon/errors/point_ownership_error'
require 'just_backgammon/errors/blocked_error'
require 'just_backgammon/errors/wrong_direction_error'
require 'just_backgammon/errors/pieces_on_bar_error'
require 'just_backgammon/errors/bear_off_error'
require 'just_backgammon/errors/dice_mismatch_error'
require 'just_backgammon/errors/moves_possible_error'

module JustBackgammon

  # = Game State
  #
  # Represents a game of Backgammon in progress.
  class GameState

    # The roll phase of the turn where the players roll dice.
    ROLL = 'roll'

    # The move phase of the turn where the players move pieces.
    MOVE = 'move'

    # A new instance of GameState.
    #
    # @param [Fixnum] current_player_number
    #   Who's turn it is, 1 or 2
    #
    # @param [Fixnum] current_phase
    #   The current phase of the turn. Either move or roll.
    #
    # @param [Array<Hash>] dice
    #   An array of dice, each with a number.
    #
    # @param [Hash] bar
    #   The bar where hit pieces go. Contains an array of pieces.
    #
    # @param [Array<Hash>] points
    #   An array of points, each with a number and an array of pieces.
    #
    # @param [Hash] off_board
    #   Off the board where pieces bear off. Contains an array of pieces.
    #
    # ==== Example:
    #   # Instantiates a new Game of Backgammon
    #   JustBackgammon::GameState.new({
    #     current_player_number: 1,
    #     current_phase: 'move',
    #     dice: [
    #       { number: 1 },
    #       { number: 4 },
    #     ],
    #     bar: {
    #       pieces: [],
    #     },
    #     points: [
    #       { number: 1, pieces: [{owner: 1}, {owner: 1}] },
    #       { number: 2, pieces: [] }
    #     ],
    #     off_board: {
    #       pieces: [],
    #     }
    #   })
    def initialize(current_player_number:, current_phase:, dice:, bar:, points:, off_board:)
      @current_player_number = current_player_number
      @current_phase = current_phase
      @dice = JustBackgammon::DiceSet.load(dice: dice)
      @bar = JustBackgammon::Bar.load(bar)
      @points = JustBackgammon::PointSet.load(points: points)
      @off_board = JustBackgammon::OffBoard.load(off_board)
      @errors = []
    end

    # Instantiates a new GameState object in the starting position
    #
    # @return [GameState]
    def self.default
      new({
        current_player_number: 1,
        current_phase: ROLL,
        dice: [
          { number: nil },
          { number: nil }
        ],
        bar: { pieces: [] },
        points: [
          { number: 1, pieces: [{owner: 1}, {owner: 1}] },
          { number: 2, pieces: [] },
          { number: 3, pieces: [] },
          { number: 4, pieces: [] },
          { number: 5, pieces: [] },
          { number: 6, pieces: [{owner: 2}, {owner: 2}, {owner: 2}, {owner: 2}, {owner: 2}] },

          { number: 7, pieces: [] },
          { number: 8, pieces: [{owner: 2}, {owner: 2}, {owner: 2}] },
          { number: 9, pieces: [] },
          { number: 10, pieces: [] },
          { number: 11, pieces: [] },
          { number: 12, pieces: [{owner: 1}, {owner: 1}, {owner: 1}, {owner: 1}, {owner: 1}] },

          { number: 13, pieces: [{owner: 2}, {owner: 2}, {owner: 2}, {owner: 2}, {owner: 2}] },
          { number: 14, pieces: [] },
          { number: 15, pieces: [] },
          { number: 16, pieces: [] },
          { number: 17, pieces: [{owner: 1}, {owner: 1}, {owner: 1}] },
          { number: 18, pieces: [] },

          { number: 19, pieces: [{owner: 1}, {owner: 1}, {owner: 1}, {owner: 1}, {owner: 1}] },
          { number: 20, pieces: [] },
          { number: 21, pieces: [] },
          { number: 22, pieces: [] },
          { number: 23, pieces: [] },
          { number: 24, pieces: [{owner: 2}, {owner: 2}] },
        ],
        off_board: { pieces: [] }
      })
    end

    # @return [Fixnum] who's turn it is
    attr_reader :current_player_number

    # @return [String] the current phase of the turn. Either move or roll
    attr_reader :current_phase

    # @return [DiceSet] an array of dice, each with a number
    attr_reader :dice

    # @return [Bar] the bar where hit pieces go. Contains an array of pieces
    attr_reader :bar

    # @return [PointSet] an array of points, each with a number and an array of pieces
    attr_reader :points

    # @return [Fixnum] who's turn it is.
    attr_reader :off_board

    # @return [Array<Error>] errors if any.
    attr_reader :errors

    # Rolls the dice
    #
    # Two dice are rolled and returns true on success.
    # The results can be found on the dice attribute.
    # If the dice have the same result, then the dice are duplicated.
    # If it's not the player's turn or the phase is move, it will return false.
    #
    # ==== Example:
    #   # Rolls the dice for player 1
    #   game_state.roll(1)
    #
    # @param [Fixnum] player_number
    #   the player number, 1 or 2.
    #
    # @return [Boolean]
    def roll(player_number)
      @errors = []

      if player_number != current_player_number
        @errors.push JustBackgammon::NotPlayersTurnError.new
      elsif current_phase != ROLL
        @errors.push JustBackgammon::WrongPhaseError.new
      else
        @dice.roll
        step
      end

      @errors.none?
    end

    # Moves each piece specified from one point, to another
    #
    # It moves each piece specified and returns true on success.
    # It returns false if the move is invalid, it's not the player's turn or the phase is roll..
    #
    # ==== Example:
    #   # Moves two pieces for player 1
    #   game_state.move(1, [{from: 1, to: 2}, {from: 3, to: 4}])
    #
    # @param [Fixnum] player_number
    #   the player number, 1 or 2.
    #
    # @param [Array<Hash>] list
    #   a list of all the moves, each containing a from and to key.
    #
    # @return [Boolean]
    def move(player_number, list)
      move_list = sanitize_list(list)

      @errors = []
      if player_number != current_player_number
        @errors.push JustBackgammon::NotPlayersTurnError.new
      elsif current_phase != MOVE
        @errors.push JustBackgammon::WrongPhaseError.new
      elsif move_valid?(move_list)
        perform_move(move_list)
        step
      end

      @errors.none?
    end

    # The player number of the winner. It returns nil if there is no winner.
    #
    # @return [Fixnum,NilClass]
    def winner
      [1, 2].find { |player_number| @off_board.number_of_pieces_owned_by_player(player_number) == 15 }
    end

    # A hashed serialized representation of the game state
    #
    # @return [Hash]
    def as_json
      {
        current_player_number: current_player_number,
        current_phase: current_phase,
        dice: dice.as_json,
        bar: bar.as_json,
        points: points.as_json,
        off_board: off_board.as_json
      }
    end

    private

    def move_valid?(move_list) # :nodoc:
      @errors = []

      case
      when move_list.any_missing_point?
        @errors.push JustBackgammon::PointNotFoundError.new
      when move_list.any_point_empty?
        @errors.push JustBackgammon::EmptyPointError.new
      when move_list.any_bar_empty_for_player?(current_player_number)
        @errors.push JustBackgammon::EmptyBarError.new
      when move_list.any_point_owned_by_opponent?(current_player_number)
        @errors.push JustBackgammon::PointOwnershipError.new
      when move_list.any_blocked?(current_player_number)
        @errors.push JustBackgammon::BlockedError.new
      when move_list.any_wrong_direction?(current_player_number)
        @errors.push JustBackgammon::WrongDirectionError.new
      when !move_list.all_moves_from_bar? && \
        move_list.number_of_moves_from_bar != bar.number_of_pieces_owned_by_player(current_player_number) && \
        points.destinations(bar, dice, current_player_number).size >= move_list.number_of_moves_from_bar
        @errors.push JustBackgammon::PiecesOnBarError.new
      when move_list.any_bear_off? && \
        !(points.not_home(current_player_number).map(&:number) - move_list.map { |m| m.from.number }).empty?
        @errors.push JustBackgammon::BearOffError.new
      when current_player_has_moves? && move_list.dice_mismatch?(current_player_number, dice)
        @errors.push JustBackgammon::DiceMismatchError.new
      end

      @errors.none?
    end

    def current_player_has_moves?  # :nodoc:
      if bar.any_pieces_for_player?(@current_player_number)
        @points.destinations(bar, @dice, @current_player_number).any?
      else
        @points.owned_by_player(@current_player_number).any? do |p|
          @points.destinations(p, @dice, @current_player_number).any?
        end
      end
    end

    def perform_move(list)  # :nodoc:
      list.each do |move|
        from = find_point(move.from.number)
        to = find_point(move.to.number)

        if to.is_a?(JustBackgammon::Point) && to.owned_by_opponent?(current_player_number) && to.blot?
          @bar.push(to.pop)
        end

        popped = if from.is_a?(JustBackgammon::Bar)
          from.pop_for_player(current_player_number)
        else
          from.pop
        end

        to.push(popped)
      end
    end

    def step  # :nodoc:
      case current_phase
      when ROLL
        @current_phase = MOVE
      when MOVE
        @current_phase = ROLL
        @dice.reset
        turn
      end
    end

    def turn  # :nodoc:
      case current_player_number
      when 1
        @current_player_number = 2
      when 2
        @current_player_number = 1
      end
    end

    def find_point(n)  # :nodoc:
      case n
      when 'bar'
        bar
      when 'off_board'
        off_board
      else
        @points.find_by_number(n.to_i)
      end
    end

    def sanitize_list(list)  # :nodoc:
      move_list = list.map do |i|
        JustBackgammon::Move.new({ from: find_point(i[:from]),  to: find_point(i[:to]) })
      end
      JustBackgammon::MoveList.new(moves: move_list)
    end
  end
end