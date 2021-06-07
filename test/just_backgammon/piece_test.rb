require "test_helper"

describe JustBackgammon::Piece do
  describe 'as json' do
    let(:piece) { JustBackgammon::Piece.new(id: 1, player_number: 1) }
    let(:json) { { id: 1, player_number: 1 } }

    it 'must serialize the piece' do
      assert_equal json, piece.as_json
    end
  end
end
