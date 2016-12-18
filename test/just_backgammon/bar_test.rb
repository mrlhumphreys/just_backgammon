require "test_helper"

describe JustBackgammon::Bar do
  describe 'initializing a bar' do
    let(:bar) { JustBackgammon::Bar.new(pieces: []) }

    it 'must set the pieces' do
      assert_equal [], bar.pieces
    end

    it 'must have a number of bar' do
      assert_equal 'bar', bar.number
    end
  end

  describe 'pieces owned by player' do
    let(:bar) { JustBackgammon::Bar.new(pieces: [{owner: 1}, {owner: 1}]) }
    let(:pieces) { bar.pieces_owned_by_player(1) }

    it 'must return the pieces owned by the player' do
      assert_equal 2, pieces.size
      assert_equal 1, pieces.first.owner
    end
  end

  describe 'number of pieces owned by player' do
    let(:bar) { JustBackgammon::Bar.new(pieces: [{owner: 1}, {owner: 1}]) }

    it 'must return the size of pieces owned by player' do
      assert_equal 2, bar.number_of_pieces_owned_by_player(1)
    end
  end

  describe 'a bar with pieces owned by a player' do
    let(:bar) { JustBackgammon::Bar.new(pieces: [{owner: 1}, {owner: 1}]) }

    it 'must not be empty for that player' do
      refute bar.empty_for_player?(1)
    end

    it 'must be empty for the other player' do
      assert bar.empty_for_player?(2)
    end

    it 'must have any for that player' do
      assert bar.any_pieces_for_player?(1)
    end

    it 'must not have any for the other player' do
      refute bar.any_pieces_for_player?(2)
    end
  end

  describe 'pop' do
    let(:bar) { JustBackgammon::Bar.new(pieces: [{owner: 1}, {owner: 2}]) }

    it 'must remove a piece from the bar for that player' do
      bar.pop(1)
      assert_equal 1, bar.pieces.size
      assert_equal 2, bar.pieces.first.owner
    end

    it 'must return that piece' do
      piece = bar.pop(1)
      assert_equal 1, piece.owner
    end
  end

  describe 'push' do
    let(:piece) { JustBackgammon::Piece.new(owner: 1) }
    let(:bar) { JustBackgammon::Bar.new(pieces: [{owner: 1}, {owner: 2}]) }

    it 'must push the piece onto the bar' do
      bar.push(piece)
      assert_equal 3, bar.pieces.size
    end
  end

  describe 'as json' do
    let(:bar) { JustBackgammon::Bar.new(pieces: []) }
    let(:json) { { pieces: [] } }

    it 'must serialize the bar' do
      assert_equal json, bar.as_json
    end
  end
end