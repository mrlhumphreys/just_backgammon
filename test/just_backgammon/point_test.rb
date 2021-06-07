require "test_helper"

describe JustBackgammon::Point do
  describe 'pop' do
    let(:point) { JustBackgammon::Point.new(pieces: [{id: 1, player_number: 1}], number: 1) }

    it 'must remove a piece from the point' do
      point.pop
      assert_equal 0, point.pieces.size
    end

    it 'must return that piece removed from the point' do
      piece = point.pop
      assert_instance_of JustBackgammon::Piece, piece
    end
  end

  describe 'push' do
    let(:piece) { JustBackgammon::Piece.new(id: 1, player_number: 1) }
    let(:point) { JustBackgammon::Point.new(pieces: [{id: 2, player_number: 1}], number: 1) }

    it 'must add a piece to the point' do
      point.push(piece)
      assert_equal 2, point.pieces.size
    end
  end

  describe 'a point with no pieces' do
    let(:point) { JustBackgammon::Point.new(pieces: [], number: 1) }

    it 'must be empty' do
      assert point.empty?
    end
  end

  describe 'a point with pieces' do
    let(:point) { JustBackgammon::Point.new(pieces: [{id: 1, player_number: 1}], number: 1) }

    it 'must not be empty' do
      refute point.empty?
    end
  end

  describe 'a point with pieces owned by player 1' do
    let(:point) { JustBackgammon::Point.new(pieces: [{id: 1, player_number: 1}], number: 1) }

    it 'must be owned by player 1' do
      assert point.owned_by_player?(1)
    end

    it 'must not be owned by player 2' do
      refute point.owned_by_player?(2)
    end

    it 'must not be owned by opponent of player 1' do
      refute point.owned_by_opponent?(1)
    end

    it 'must be owned by opponent of player 2' do
      assert point.owned_by_opponent?(2)
    end
  end

  describe 'a point with one piece' do
    let(:point) { JustBackgammon::Point.new(pieces: [{id: 1, player_number: 1}], number: 1) }

    it 'must not be blocked' do
      refute point.blocked?
    end
  end

  describe 'a point with two pieces' do
    let(:point) { JustBackgammon::Point.new(pieces: [{id: 1, player_number: 1}, {id: 2, player_number: 1}], number: 1) }

    it 'must be blocked' do
      assert point.blocked?
    end
  end

  describe 'a point between 1 and 6' do
    let(:point) { JustBackgammon::Point.new(pieces: [], number: 4) }

    it 'must not be home for player 1' do
      refute point.home?(1)
    end

    it 'must be home for player 2' do
      assert point.home?(2)
    end
  end

  describe 'a point between 19 and 24' do
    let(:point) { JustBackgammon::Point.new(pieces: [], number: 21) }

    it 'must not be home for player 2' do
      refute point.home?(2)
    end

    it 'must be home for player 1' do
      assert point.home?(1)
    end
  end

  describe 'as json' do
    let(:point) { JustBackgammon::Point.new(pieces: [], number: 1) }
    let(:json) { { pieces: [], number: 1 } }

    it 'must serialize the point' do
      assert_equal json, point.as_json
    end
  end
end
