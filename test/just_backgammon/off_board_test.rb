require "test_helper"

describe JustBackgammon::OffBoard do
  describe 'as json' do
    let(:off_board) { JustBackgammon::OffBoard.new(pieces: []) }
    let(:json) { { pieces: [] } }

    it 'must serialize the off board' do
      assert_equal json, off_board.as_json
    end
  end

  describe 'pieces owned by player' do
    let(:off_board) { JustBackgammon::OffBoard.new(pieces: [{id: 1, owner: 1}, {id: 2, owner: 1}]) }
    let(:pieces) { off_board.pieces_owned_by_player(1) }

    it 'must return the pieces owned by the player' do
      assert_equal 2, pieces.size
      assert_equal 1, pieces.first.owner
    end
  end

  describe 'number of pieces owned by player' do
    let(:player) { 1 }
    let(:other_player) { 2 }
    let(:off_board) { JustBackgammon::OffBoard.new(pieces: [{id: 1, owner: player}, {id: 2, owner: player}, {id: 3, owner: other_player}]) }

    it 'must return the number of pieces owned by the player' do
      assert_equal 2, off_board.number_of_pieces_owned_by_player(player)
    end
  end

  describe 'push' do
    let(:off_board) { JustBackgammon::OffBoard.new(pieces: []) }
    let(:piece) { JustBackgammon::Piece.new(id: 1, owner: 1) }

    it 'must add the piece to off board' do
      off_board.push(piece)
      assert_equal 1, off_board.pieces.size
    end
  end
end