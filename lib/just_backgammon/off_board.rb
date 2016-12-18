require 'just_backgammon/off_board'
require 'just_backgammon/piece'

module JustBackgammon

  # = OffBoard
  #
  # The off board is where pieces go when bearing off. Contains an array of pieces.
  class OffBoard
    extend Common

    # A new instance of OffBoard.
    #
    # @param [Array<Hash>] pieces
    #   All the pieces off board, each piece has an owner.
    #
    # ==== Example:
    #   # Instantiates a new OffBoard
    #   JustBackgammon::OffBoard.new({
    #     pieces: [{owner: 1}, {owner: 1}]
    #   })
    def initialize(pieces:)
      @pieces = Piece.load(pieces)
    end

    # @return [Array<Piece>] all the pieces on the bar, each piece has an owner
    attr_reader :pieces

    # The identifier of the bar, returns the string 'bar'.
    #
    # @return [String]
    def number
      'off_board'
    end

    # ALl the pieces owned by the specified player.
    #
    # @param [Fixnum] player_number
    #   the specified player number.
    #
    # @return [Array<Piece>]
    def pieces_owned_by_player(player_number)
      pieces.select { |p| p.owner == player_number }
    end

    # Number of pieces owned by the specified player.
    #
    # @param [Fixnum] player_number
    #   the specified player number.
    #
    # @return [Fixnum]
    def number_of_pieces_owned_by_player(player_number)
      pieces_owned_by_player(player_number).size
    end

    # Adds a piece off board.
    #
    # @param [Piece] piece
    #   the piece to push off board.
    #
    # @return [Array<Piece>]
    def push(piece)
      @pieces.push(piece)
    end

    def hittable?(_=nil)
      false
    end

    # A hashed serialized representation of off board.
    #
    # @return [Hash]
    def as_json
      { pieces: pieces.map(&:as_json) }
    end
  end
end