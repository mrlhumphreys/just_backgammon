require "test_helper"

describe JustBackgammon::Piece do
  describe 'as json' do
    let(:piece) { JustBackgammon::Piece.new(owner: 1) }
    let(:json) { { owner: 1 } }
    
    it 'must serialize the piece' do
      assert_equal json, piece.as_json
    end
  end
end