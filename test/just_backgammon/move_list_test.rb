require "test_helper"

describe JustBackgammon::MoveList do
  let(:player) { 1 }
  let(:other_player) { 2 }
  let(:move_a) { JustBackgammon::Move.new(from: from_a, to: to_a) }
  let(:move_b) { JustBackgammon::Move.new(from: from_b, to: to_b) }
  let(:move_list) { JustBackgammon::MoveList.new(moves: [move_a, move_b]) }

  describe 'an ordinary move list' do
    let(:from_a) { JustBackgammon::Point.new(number: 1, pieces: [{owner: player}]) }
    let(:to_a) { JustBackgammon::Point.new(number: 2, pieces: []) }

    let(:from_b) { JustBackgammon::Point.new(number: 3, pieces: [{owner: player}]) }
    let(:to_b) { JustBackgammon::Point.new(number: 4, pieces: []) }

    it 'must not be missing a point' do
      refute move_list.any_missing_point?
    end

    it 'must not have an empty point' do
      refute move_list.any_point_empty?
    end

    it 'must not have a combined move' do
      combined_moves = move_list.combined_moves
      assert_equal 2, combined_moves.size
      assert_equal [1,2], combined_moves.first.legs.map(&:number)
      assert_equal [3,4], combined_moves.last.legs.map(&:number)
    end

    it 'must not have the same piece multiple times' do
      refute move_list.piece_moves_multiple_times?
    end

    it 'must not have any points owned by opponent' do
      refute move_list.any_point_owned_by_opponent?(player)
    end

    it 'must not have any empty bar' do
      refute move_list.any_bar_empty_for_player?(player)
    end

    it 'must not have any empty bar' do
      refute move_list.any_blocked?(player)
    end

    it 'must not have any in the wrong direction' do
      refute move_list.any_wrong_direction?(player)
    end

    it 'must not have any bearing off' do
      refute move_list.any_bear_off?
    end
  end

  describe 'a move list with empty froms that match tos' do
    let(:from_a) { JustBackgammon::Point.new(number: 1, pieces: [{owner: player}]) }
    let(:to_a) { JustBackgammon::Point.new(number: 2, pieces: []) }

    let(:from_b) { JustBackgammon::Point.new(number: 2, pieces: []) }
    let(:to_b) { JustBackgammon::Point.new(number: 3, pieces: []) }

    it 'must have a combined move' do
      combined_moves = move_list.combined_moves
      assert_equal 1, combined_moves.size
      assert_equal [1,2,3], combined_moves.first.legs.map(&:number)
    end

    it 'must move the same piece multiple times' do
      assert move_list.piece_moves_multiple_times?
    end

    it 'must not be missing a point' do
      refute move_list.any_missing_point?
    end

    it 'must not have any points owned by opponent' do
      refute move_list.any_point_owned_by_opponent?(player)
    end
  end

  describe 'a move list a piece moving through a blot' do
    let(:from_a) { JustBackgammon::Point.new(number: 1, pieces: [{owner: player}]) }
    let(:to_a) { JustBackgammon::Point.new(number: 2, pieces: [{owner: other_player}]) }

    let(:from_b) { JustBackgammon::Point.new(number: 2, pieces: [{owner: other_player}]) }
    let(:to_b) { JustBackgammon::Point.new(number: 3, pieces: []) }

    it 'must move the same piece multiple times' do
      assert move_list.piece_moves_multiple_times?
    end
  end

  describe 'a move list with a move missing a point' do
    let(:from_a) { JustBackgammon::Point.new(number: 1, pieces: [{owner: player}]) }
    let(:to_a) { JustBackgammon::Point.new(number: 2, pieces: []) }

    let(:from_b) { JustBackgammon::Point.new(number: 3, pieces: [{owner: player}]) }
    let(:to_b) { nil }

    it 'must be missing a point' do
      assert move_list.any_missing_point?
    end
  end

  describe 'a move list with an empty from' do
    let(:from_a) { JustBackgammon::Point.new(number: 1, pieces: []) }
    let(:to_a) { JustBackgammon::Point.new(number: 2, pieces: []) }

    let(:from_b) { JustBackgammon::Point.new(number: 3, pieces: [{owner: player}]) }
    let(:to_b) { JustBackgammon::Point.new(number: 4, pieces: []) }

    it 'must have an empty point' do
      assert move_list.any_point_empty?
    end
  end

  describe 'a move list with a combined move and an empty from' do
    let(:from_a) { JustBackgammon::Point.new(number: 1, pieces: []) }
    let(:to_a) { JustBackgammon::Point.new(number: 2, pieces: []) }

    let(:from_b) { JustBackgammon::Point.new(number: 2, pieces: [{owner: player}]) }
    let(:to_b) { JustBackgammon::Point.new(number: 3, pieces: []) }

    it 'must have an empty point' do
      assert move_list.any_point_empty?
    end
  end

  describe 'a move list with points owned by an opponent' do
    let(:from_a) { JustBackgammon::Point.new(number: 1, pieces: [{owner: other_player}]) }
    let(:to_a) { JustBackgammon::Point.new(number: 2, pieces: []) }

    let(:from_b) { JustBackgammon::Point.new(number: 3, pieces: [{owner: player}]) }
    let(:to_b) { JustBackgammon::Point.new(number: 4, pieces: []) }

    it 'must have a point owned by an opponent' do
      assert move_list.any_point_owned_by_opponent?(player)
    end
  end

  describe 'a move list with a combined move and points owned by an opponent' do
    let(:from_a) { JustBackgammon::Point.new(number: 1, pieces: [{owner: other_player}]) }
    let(:to_a) { JustBackgammon::Point.new(number: 2, pieces: []) }

    let(:from_b) { JustBackgammon::Point.new(number: 2, pieces: []) }
    let(:to_b) { JustBackgammon::Point.new(number: 3, pieces: []) }

    it 'must have a point owned by an opponent' do
      assert move_list.any_point_owned_by_opponent?(player)
    end
  end

  describe 'a move list with an empty bar' do
    let(:from_a) { JustBackgammon::Bar.new(pieces: []) }
    let(:to_a) { JustBackgammon::Point.new(number: 2, pieces: []) }

    let(:from_b) { JustBackgammon::Point.new(number: 2, pieces: []) }
    let(:to_b) { JustBackgammon::Point.new(number: 3, pieces: []) }

    it 'must have any empty bar' do
      assert move_list.any_bar_empty_for_player?(player)
    end
  end

  describe 'a move list with a bar with pieces owned by player' do
    let(:from_a) { JustBackgammon::Bar.new(pieces: [{owner: player}]) }
    let(:to_a) { JustBackgammon::Point.new(number: 2, pieces: []) }

    let(:from_b) { JustBackgammon::Point.new(number: 2, pieces: []) }
    let(:to_b) { JustBackgammon::Point.new(number: 3, pieces: []) }

    it 'must not have any empty bar' do
      refute move_list.any_bar_empty_for_player?(player)
    end
  end

  describe 'a move list with any blocked' do
    let(:from_a) { JustBackgammon::Point.new(number: 1, pieces: [{owner: 1}]) }
    let(:to_a) { JustBackgammon::Point.new(number: 2, pieces: [{owner: 2}, {owner: 2}]) }

    let(:from_b) { JustBackgammon::Point.new(number: 2, pieces: []) }
    let(:to_b) { JustBackgammon::Point.new(number: 3, pieces: []) }

    it 'must have any blocked' do
      assert move_list.any_blocked?(player)
    end
  end

  describe 'a move list with any blocked' do
    let(:from_a) { JustBackgammon::Point.new(number: 2, pieces: [{owner: 1}]) }
    let(:to_a) { JustBackgammon::Point.new(number: 1, pieces: []) }

    let(:from_b) { JustBackgammon::Point.new(number: 3, pieces: []) }
    let(:to_b) { JustBackgammon::Point.new(number: 4, pieces: []) }

    it 'must have any blocked' do
      assert move_list.any_wrong_direction?(player)
    end
  end

  describe 'a move list with one bearing off' do
    let(:from_a) { JustBackgammon::Point.new(number: 1, pieces: [{owner: 1}]) }
    let(:to_a) { JustBackgammon::Point.new(number: 2, pieces: []) }

    let(:from_b) { JustBackgammon::Point.new(number: 24, pieces: [{owner: 1}]) }
    let(:to_b) { JustBackgammon::OffBoard.new(pieces: []) }

    it 'must have any blocked' do
      assert move_list.any_bear_off?
    end
  end

  describe 'a move list with all moves from the bar' do
    let(:from_a) { JustBackgammon::Bar.new(pieces: [{owner: 1}, {owner: 1}]) }
    let(:to_a) { JustBackgammon::Point.new(number: 2, pieces: []) }

    let(:from_b) { JustBackgammon::Bar.new(pieces: [{owner: 1}, {owner: 1}]) }
    let(:to_b) { JustBackgammon::Point.new(number: 3, pieces: []) }

    it 'must be all from the bar' do
      assert move_list.all_moves_from_bar?
    end
  end

  describe 'a move with two moves from bar' do
    let(:from_a) { JustBackgammon::Bar.new(pieces: [{owner: 1}, {owner: 1}]) }
    let(:to_a) { JustBackgammon::Point.new(number: 2, pieces: []) }

    let(:from_b) { JustBackgammon::Bar.new(pieces: [{owner: 1}, {owner: 1}]) }
    let(:to_b) { JustBackgammon::Point.new(number: 1, pieces: []) }

    it 'must have two moves from bar' do
      assert_equal 2, move_list.number_of_moves_from_bar
    end
  end

  describe 'absolute distance' do
    let(:from_a) { JustBackgammon::Point.new(number: 1, pieces: [{owner: 1}]) }
    let(:to_a) { JustBackgammon::Point.new(number: 2, pieces: []) }

    let(:from_b) { JustBackgammon::Point.new(number: 3, pieces: [{owner: 1}]) }
    let(:to_b) { JustBackgammon::Point.new(number: 5, pieces: []) }

    it 'must return the absolute distances of each move' do
      assert_equal [1, 2], move_list.absolute_distances(player)
    end
  end
end