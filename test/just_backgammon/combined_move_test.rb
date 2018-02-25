require "test_helper"

describe JustBackgammon::CombinedMove do
  let(:combined_move) { JustBackgammon::CombinedMove.new(legs: legs) }
  let(:player) { 1 }
  let(:other_player) { 2 }

  describe 'with a point as the first leg' do
    let(:legs) { [JustBackgammon::Point.new(number: 1, pieces: [])] }

    it 'must be from point' do
      assert combined_move.from_point?
    end
  end

  describe 'with a bar as the first leg' do
    let(:legs) { [JustBackgammon::Bar.new(pieces: [])] }

    it 'must not be from point' do
      refute combined_move.from_point?
    end
  end

  describe 'with a point that has no pieces on the first leg' do
    let(:legs) { [JustBackgammon::Point.new(number: 1, pieces: [])] }

    it 'must be empty' do
      assert combined_move.empty?
    end
  end

  describe 'with a point that has pieces on the first leg' do
    let(:legs) { [JustBackgammon::Point.new(number: 1, pieces: [{id: 1, owner: player}])] }

    it 'must not be empty' do
      refute combined_move.empty?
    end
  end

  describe 'with a point that has pieces owned by the player' do
    let(:legs) { [JustBackgammon::Point.new(number: 1, pieces: [{id: 1, owner: player}])] }

    it 'must not be owned by the opponent' do
      refute combined_move.owned_by_opponent?(player)
    end
  end

  describe 'with a point that has pieces not owned by the player' do
    let(:legs) { [JustBackgammon::Point.new(number: 1, pieces: [{id: 1, owner: other_player}])] }

    it 'must be owned by the opponent' do
      assert combined_move.owned_by_opponent?(player)
    end
  end
end