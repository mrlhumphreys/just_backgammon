require 'just_backgammon/common'
require 'just_backgammon/piece'

module JustBackgammon

  # = Point
  #
  # A point where pieces can land on. Each one has a number.
  class Point
    extend Common
    extend Forwardable

    # A new instance of Point.
    #
    # @param [Array<Hash>] pieces
    #   All the pieces on this point.
    #
    # @param [Fixnum] number
    #   The point number and identifier.
    #
    # ==== Example:
    #   # Instantiates a new Point
    #   JustBackgammon::Point.new({
    #     pieces: [{owner: 1}, {owner: 1}],
    #     number: 1
    #   })
    def initialize(pieces: , number:)
      @pieces = JustBackgammon::Piece.load(pieces)
      @number = number
    end

    # @return [Array<Piece>] all the pieces on this point
    attr_reader :pieces

    # @return [Fixnum] the point number and identifier
    attr_reader :number

    def_delegator :pieces, :size
    def_delegator :pieces, :empty?

    # Removes a piece and returns it.
    #
    # @return [Piece,NilClass]
    def pop
      @pieces.pop
    end

    # Adds a piece to the point.
    #
    # @return [Array<Piece>]
    def push(piece)
      @pieces.push(piece)
    end

    # Checks if point has pieces owned by the specified player.
    #
    # @return [Boolean]
    def owned_by_player?(player_number)
      pieces.any? { |p| p.owner == player_number }
    end

    # Checks if point has pieces owned by the opponent of the specified player.
    #
    # @return [Boolean]
    def owned_by_opponent?(player_number)
      pieces.any? { |p| p.owner != player_number }
    end

    # Checks if point has more than one piece.
    #
    # @return [Boolean]
    def blocked?
      size > 1
    end

    # Checks if point has only one piece.
    #
    # @return [Boolean]
    def blot?
      size == 1
    end

    # Checks if point is a home point for specified player.
    #
    # @return [Boolean]
    def home?(player_number)
      case player_number
      when 1
        (19..24).include?(number)
      when 2
        (1..6).include?(number)
      else
        true
      end
    end

    # A hashed serialized representation of the bar.
    #
    # @return [Hash]
    def as_json
      { number: number, pieces: pieces.map(&:as_json) }
    end
  end
end