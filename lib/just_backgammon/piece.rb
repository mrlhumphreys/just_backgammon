require 'just_backgammon/common'

module JustBackgammon

  # = Piece
  #
  # A piece owned by a player that moves around the board.
  class Piece
    extend Common

    # A new instance of Piece.
    #
    # @param [Fixnum] owner
    #   The owner of the piece.
    #
    # ==== Example:
    #   # Instantiates a new Piece
    #   JustBackgammon::Piece.new(1)
    def initialize(owner:)
      @owner = owner
    end

    # @return [Fixnum] the owner of the piece
    attr_reader :owner

    # A hashed serialized representation of the piece.
    #
    # @return [Hash]
    def as_json
      { owner: owner }
    end
  end
end