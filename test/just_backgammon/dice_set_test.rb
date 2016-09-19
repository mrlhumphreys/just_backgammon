require "test_helper"

describe JustBackgammon::DiceSet do
  describe 'find_by_number' do
    let(:dice_set) { JustBackgammon::DiceSet.new(dice: [{number: 1}, {number: 4}]) }

    it 'must return the die matching the number' do
      die = dice_set.find_by_number(4)
      assert_equal 4, die.number
    end
  end

  describe 'numbers' do
    let(:dice_set) { JustBackgammon::DiceSet.new(dice: [{number: 1}, {number: 4}]) }

    it 'must return the numbers of the dice' do
      assert_equal [1, 4], dice_set.numbers
    end
  end

  describe 'roll' do
    let(:dice_set) { JustBackgammon::DiceSet.new(dice: [{number: nil}, {number: nil}]) }

    it 'must roll each dice' do
      dice_set.roll
      assert dice_set.numbers.none?(&:nil?)
    end

    describe 'when double dice are rolled' do
      it 'must duplicate them' do
        mock_random = Minitest::Mock.new
        mock_random.stub :rand, 0 do
          Random.stub :new, mock_random do
            dice_set.roll
            assert_equal 4, dice_set.dice.size
          end
        end
      end
    end
  end

  describe 'reset' do
    let(:dice_set) { JustBackgammon::DiceSet.new(dice: [{number: 1}, {number: 1}, {number: 1}, {number: 1}]) }

    it 'must reset all dice' do
      dice_set.reset
      assert dice_set.numbers.all?(&:nil?)
    end

    it 'must have two dice' do
      dice_set.reset
      assert_equal 2, dice_set.dice.size
    end
  end

  describe 'as json' do
    let(:dice_set) { JustBackgammon::DiceSet.new(dice: [{number: 1}, {number: 4}]) }
    let(:json) { [{number: 1}, {number: 4}] }

    it 'must return the dice as json' do
      assert_equal json, dice_set.as_json
    end
  end
end