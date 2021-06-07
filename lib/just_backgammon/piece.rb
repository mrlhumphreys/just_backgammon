require 'just_backgammon/common'

module JustBackgammon

  # = Piece
  #
  # A piece owned by a player that moves around the board.
  class Piece
    extend Common

    # A new instance of Piece.
    #
    # @param [Fixnum] id
    #   The identifier of the piece.
    #
    # @param [Fixnum] player_number
    #   The owner of the piece.
    #
    # ==== Example:
    #   # Instantiates a new Piece
    #   JustBackgammon::Piece.new(id: 1, player_number: 1)
    def initialize(id: , player_number:)
      @id = id
      @player_number = player_number
    end

    # @return [Fixnum] the identifier of the piece.
    attr_reader :id

    # @return [Fixnum] the owner of the piece
    attr_reader :player_number

    # A hashed serialized representation of the piece.
    #
    # @return [Hash]
    def as_json
      { id: id, player_number: player_number }
    end
  end
end
