require 'just_backgammon/common'
require 'just_backgammon/piece'

module JustBackgammon

  # = Bar
  #
  # The bar is where hit pieces go. Contains an array of pieces.
  class Bar
    extend Common
    extend Forwardable

    # A new instance of Bar.
    #
    # @param [Array<Hash>] pieces
    #   All the pieces on the bar, each piece has an owner.
    #
    # ==== Example:
    #   # Instantiates a new Bar
    #   JustBackgammon::Bar.new({
    #     pieces: [{owner: 1}, {owner: 1}]
    #   })
    def initialize(pieces:)
      @pieces = JustBackgammon::Piece.load(pieces)
    end

    # @return [Array<Piece>] all the pieces on the bar, each piece has an owner
    attr_reader :pieces

    def_delegator :pieces, :empty?

    # The identifier of the bar, returns the string 'bar'.
    #
    # @return [String]
    def number
      'bar'
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

    # If the player has any pieces.
    #
    # @param [Fixnum] player_number
    #   the specified player number.
    #
    # @return [Boolean]
    def any_pieces_for_player?(player_number)
      pieces_owned_by_player(player_number).any?
    end

    # If the player has no pieces.
    #
    # @param [Fixnum] player_number
    #   the specified player number.
    #
    # @return [Boolean]
    def empty_for_player?(player_number)
      pieces_owned_by_player(player_number).none?
    end

    # Removes a piece owned by the specified player and return it.
    #
    # @param [Fixnum] player_number
    #   the specified player number.
    #
    # @return [Piece,NilClass]
    def pop_for_player(player_number)
      p = pieces.find { |p| p.owner == player_number }
      pieces.delete(p)
    end

    # Adds a piece to the bar.
    #
    # @param [Piece] piece
    #   the piece to push onto the bar.
    #
    # @return [Array<Piece>]
    def push(piece)
      pieces.push(piece)
    end

    # A hashed serialized representation of the bar.
    #
    # @return [Hash]
    def as_json
      { pieces: pieces.map(&:as_json) }
    end
  end
end