require "test_helper"

describe JustBackgammon::Move do

  describe 'for player one' do
    let(:player) { 1 }
    let(:move) { JustBackgammon::Move.new(from: from, to: to) }

    describe 'from and to are points' do
      let(:from) { JustBackgammon::Point.new(number: 1, pieces: [{owner: 1}]) }
      let(:to) { JustBackgammon::Point.new(number: 4, pieces: []) }

      it 'must have a distance equal to the difference between the two points' do
        assert_equal 3, move.distance_for_player(player)
      end

      it 'must have an absolute distance equal to the difference between the two points' do
        assert_equal 3, move.absolute_distance_for_player(player)
      end
    end

    describe 'from is the bar' do
      let(:from) { JustBackgammon::Bar.new(pieces: [{owner: 1}]) }
      let(:to) { JustBackgammon::Point.new(number: 2, pieces: []) }

      it 'must have a distance equal to the difference between 0 and to' do
        assert_equal 2, move.distance_for_player(player)
      end

      it 'must have a absolute distance equal to the difference between 0 and to' do
        assert_equal 2, move.absolute_distance_for_player(player)
      end
    end

    describe 'to is off board' do
      let(:from) { JustBackgammon::Point.new(number: 23, pieces: [{owner: 1}]) }
      let(:to) { JustBackgammon::OffBoard.new(pieces: []) }

      it 'must have a distance equal to the difference between from and 25' do
        assert_equal 2, move.distance_for_player(player)
      end

      it 'must have a absolute distance equal to the difference between from and 25' do
        assert_equal 2, move.absolute_distance_for_player(player)
      end
    end
  end

  describe 'for player two' do
    let(:player) { 2 }
    let(:move) { JustBackgammon::Move.new(from: from, to: to) }

    describe 'from and to are points' do
      let(:from) { JustBackgammon::Point.new(number: 24, pieces: [{owner: 2}]) }
      let(:to) { JustBackgammon::Point.new(number: 21, pieces: []) }

      it 'must have a distance equal to the difference between the two points' do
        assert_equal -3, move.distance_for_player(player)
      end

      it 'must have a absolute distance equal to the difference between the two points' do
        assert_equal 3, move.absolute_distance_for_player(player)
      end
    end

    describe 'from is the bar' do
      let(:from) { JustBackgammon::Bar.new(pieces: [{owner: 2}]) }
      let(:to) { JustBackgammon::Point.new(number: 21, pieces: []) }

      it 'must have a distance equal to the difference between 0 and to' do
        assert_equal -4, move.distance_for_player(player)
      end

      it 'must have a absolute distance equal to the difference between 0 and to' do
        assert_equal 4, move.absolute_distance_for_player(player)
      end
    end

    describe 'to is off board' do
      let(:from) { JustBackgammon::Point.new(number: 2, pieces: [{owner: 2}]) }
      let(:to) { JustBackgammon::OffBoard.new(pieces: []) }

      it 'must have a distance equal to the difference between from and 25' do
        assert_equal -2, move.distance_for_player(player)
      end

      it 'must have a distance equal to the difference between from and 25' do
        assert_equal 2, move.absolute_distance_for_player(player)
      end
    end
  end

  describe 'an increasing move' do
    let(:from) { JustBackgammon::Point.new(number: 1, pieces: [{owner: player}]) }
    let(:to) { JustBackgammon::Point.new(number: 3, pieces: []) }
    let(:move) { JustBackgammon::Move.new(from: from, to: to) }

    describe 'for player one' do
      let(:player) { 1 }

      it 'must be in the right direction' do
        refute move.wrong_direction?(player)
      end
    end

    describe 'for player two' do
      let(:player) { 2 }

      it 'must be in the wrong direction' do
        assert move.wrong_direction?(player)
      end
    end
  end

  describe 'a decreasing move' do
    let(:from) { JustBackgammon::Point.new(number: 3, pieces: [{owner: player}]) }
    let(:to) { JustBackgammon::Point.new(number: 1, pieces: []) }
    let(:move) { JustBackgammon::Move.new(from: from, to: to) }

    describe 'for player one' do
      let(:player) { 1 }

      it 'must be in the wrong direction' do
        assert move.wrong_direction?(player)
      end
    end

    describe 'for player two' do
      let(:player) { 2 }

      it 'must be in the right direction' do
        refute move.wrong_direction?(player)
      end
    end
  end

  describe 'a move to off board' do
    let(:player) { 1 }
    let(:from) { JustBackgammon::Point.new(number: 24, pieces: [{owner: 1}]) }
    let(:to) { JustBackgammon::OffBoard.new(pieces: []) }
    let(:move) { JustBackgammon::Move.new(from: from, to: to) }

    it 'must not be blocked' do
      refute move.blocked?(player)
    end
  end

  describe 'to an empty point' do
    let(:player) { 1 }
    let(:from) { JustBackgammon::Point.new(number: 1, pieces: [{owner: 1}]) }
    let(:to) { JustBackgammon::Point.new(number: 2, pieces: []) }
    let(:move) { JustBackgammon::Move.new(from: from, to: to) }

    it 'must not be blocked' do
      refute move.blocked?(player)
    end
  end

  describe 'a move to a point owned by the player' do
    let(:player) { 1 }
    let(:from) { JustBackgammon::Point.new(number: 1, pieces: [{owner: 1}]) }
    let(:to) { JustBackgammon::Point.new(number: 2, pieces: [{owner: 1}, {owner: 1}]) }
    let(:move) { JustBackgammon::Move.new(from: from, to: to) }

    it 'must not be blocked' do
      refute move.blocked?(player)
    end
  end

  describe 'a move to a point owned by the opponent' do
    describe 'and the point has one piece' do
      let(:player) { 1 }
      let(:from) { JustBackgammon::Point.new(number: 1, pieces: [{owner: 1}]) }
      let(:to) { JustBackgammon::Point.new(number: 2, pieces: [{owner: 2}]) }
      let(:move) { JustBackgammon::Move.new(from: from, to: to) }

      it 'must not be blocked' do
        refute move.blocked?(player)
      end
    end

    describe 'and the point has more than one piece' do
      let(:player) { 1 }
      let(:from) { JustBackgammon::Point.new(number: 1, pieces: [{owner: 1}]) }
      let(:to) { JustBackgammon::Point.new(number: 2, pieces: [{owner: 2}, {owner: 2}]) }
      let(:move) { JustBackgammon::Move.new(from: from, to: to) }

      it 'must be blocked' do
        assert move.blocked?(player)
      end
    end
  end

  describe 'a move with a from and to' do
    let(:from) { JustBackgammon::Point.new(number: 1, pieces: [{owner: 1}]) }
    let(:to) { JustBackgammon::Point.new(number: 2, pieces: []) }
    let(:move) { JustBackgammon::Move.new(from: from, to: to) }

    it 'must not be missing point' do
      refute move.missing_point?
    end
  end

  describe 'a move without a from' do
    let(:from) { nil }
    let(:to) { JustBackgammon::Point.new(number: 2, pieces: []) }
    let(:move) { JustBackgammon::Move.new(from: from, to: to) }

    it 'must be missing point' do
      assert move.missing_point?
    end
  end

  describe 'a move without a to' do
    let(:from) { JustBackgammon::Point.new(number: 1, pieces: [{owner: 1}]) }
    let(:to) { nil }
    let(:move) { JustBackgammon::Move.new(from: from, to: to) }

    it 'must be missing point' do
      assert move.missing_point?
    end
  end

  describe 'a move where the from is a point' do
    let(:from) { JustBackgammon::Point.new(number: 1, pieces: [{owner: 1}]) }
    let(:to) { JustBackgammon::Point.new(number: 2, pieces: []) }
    let(:move) { JustBackgammon::Move.new(from: from, to: to) }

    it 'must not be from bar' do
      refute move.from_bar?
    end
  end

  describe 'a move where the from is the bar' do
    let(:from) { JustBackgammon::Bar.new(pieces: [{owner: 1}]) }
    let(:to) { JustBackgammon::Point.new(number: 2, pieces: []) }
    let(:move) { JustBackgammon::Move.new(from: from, to: to) }

    it 'must be from bar' do
      assert move.from_bar?
    end
  end

  describe 'a move where the to is off board' do
    let(:from) { JustBackgammon::Point.new(number: 1, pieces: [{owner: 1}]) }
    let(:to) { JustBackgammon::OffBoard.new(pieces: []) }
    let(:move) { JustBackgammon::Move.new(from: from, to: to) }

    it 'must be a bear off move' do
      assert move.bear_off?
    end

    it 'must not be to point' do
      refute move.to_point?
    end
  end

  describe 'a move where the to is a point' do
    let(:from) { JustBackgammon::Point.new(number: 1, pieces: [{owner: 1}]) }
    let(:to) { JustBackgammon::Point.new(number: 2, pieces: []) }
    let(:move) { JustBackgammon::Move.new(from: from, to: to) }

    it 'must not be a bear off move' do
      refute move.bear_off?
    end

    it 'must be to point' do
      assert move.to_point?
    end
  end
end