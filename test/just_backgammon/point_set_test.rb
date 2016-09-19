require "test_helper"

describe JustBackgammon::PointSet do
  describe 'finding a point by number' do
    let(:point_set) { JustBackgammon::PointSet.new(points: [{number: 1, pieces: []}]) }

    it 'must return the point matching the number' do
      point = point_set.find_by_number(1)
      assert_instance_of JustBackgammon::Point, point
      assert_equal 1, point.number
    end
  end

  describe 'when player 1 has a piece between points 1 to 18' do
    let(:point_set) { JustBackgammon::PointSet.new(points: [{number: 9, pieces: [{owner: 1}]}]) }

    it 'must have points with pieces that are not home' do
      assert_equal 1, point_set.not_home(1).size
    end

    it 'must have some pieces that are not home' do
      assert point_set.some_pieces_not_home?(1)
    end
  end

  describe 'when player 1 has no pieces between points 1 to 18' do
    let(:point_set) { JustBackgammon::PointSet.new(points: [{number: 21, pieces: [{owner: 1}]}]) }

    it 'must not have points with pieces that are not home' do
      assert_equal 0, point_set.not_home(1).size
    end

    it 'must not have any pieces that are not home' do
      refute point_set.some_pieces_not_home?(1)
    end
  end

  describe 'when player 2 has a piece between points 7 to 24' do
    let(:point_set) { JustBackgammon::PointSet.new(points: [{number: 16, pieces: [{owner: 2}]}]) }

    it 'must have points with pieces that are not home' do
      assert_equal 1, point_set.not_home(2).size
    end

    it 'must have some pieces that are not homme' do
      assert point_set.some_pieces_not_home?(2)
    end
  end

  describe 'when player 2 has no pieces between points 7 to 24' do
    let(:point_set) { JustBackgammon::PointSet.new(points: [{number: 4, pieces: [{owner: 2}]}]) }

    it 'must not have points with pieces that are not home' do
      assert_equal 0, point_set.not_home(2).size
    end

    it 'must not have any pieces that are not home' do
      refute point_set.some_pieces_not_home?(2)
    end
  end

  describe 'finding points owned by a player' do
    let(:point_set) {
      JustBackgammon::PointSet.new(
        points: [
          {number: 1, pieces: [{owner: 1}]},
          {number: 2, pieces: [{owner: 2}]},
          {number: 3, pieces: []}
        ]
      )
    }

    it 'must return points that have pieces owned by that player' do
      assert_equal 1, point_set.owned_by_player(1).points.size
      assert_equal 1, point_set.owned_by_player(1).points.first.number
    end
  end

  describe 'given a point set, a from point, dice and a player' do
    let(:point_set) {
      JustBackgammon::PointSet.new(
        points: [
          {number: 1, pieces: [{owner: 1}]},
          {number: 2, pieces: [{owner: 2}, {owner: 2}]},
          {number: 3, pieces: []}
        ]
      )
    }

    let(:from) { JustBackgammon::Point.new(number: 1, pieces: [{owner: 1}]) }
    let(:dice) { JustBackgammon::DiceSet.new(dice: [{number: 1}, {number: 2}]) }
    let(:player_number) { 1 }

    it 'must have destinations' do
      destinations = point_set.destinations(from, dice, player_number)
      assert_equal 1, destinations.points.size
      assert_equal 3, destinations.points.first.number
    end
  end

  describe 'as_json' do
    let(:point_set) { JustBackgammon::PointSet.new(points: [{number: 1, pieces: [{owner: 1}]}]) }
    let(:json) { [{number: 1, pieces: [{owner: 1}]}] }

    it 'must return the serialized representation of the points' do
      assert_equal json, point_set.as_json
    end
  end
end