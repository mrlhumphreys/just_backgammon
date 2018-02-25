require "test_helper"

describe JustBackgammon::Die do
  describe 'roll' do
    let(:die) { JustBackgammon::Die.new(id: 1, number: nil) }

    it 'must set the number to a value from 1 to 6' do
      die.roll
      assert_includes (1..6).to_a, die.number
    end
  end

  describe 'reset' do
    let(:die) { JustBackgammon::Die.new(id: 1, number: 5) }

    it 'must set the number to nil' do
      die.reset
      assert_nil die.number
    end
  end

  describe 'dice with the same numbers' do
    let(:die_a) { JustBackgammon::Die.new(id: 1, number: 1) }
    let(:die_b) { JustBackgammon::Die.new(id: 2, number: 1) }

    it 'must be equal' do
      assert_equal die_a, die_b
    end
  end

  describe 'dice with different numbers' do
    let(:die_a) { JustBackgammon::Die.new(id: 1, number: 1) }
    let(:die_b) { JustBackgammon::Die.new(id: 2, number: 4) }

    it 'must not be equal' do
      refute_equal die_a, die_b
    end
  end

  describe 'as json' do
    let(:die) { JustBackgammon::Die.new(id: 1, number: 1) }

    let(:json) { { id: 1, number: 1 } }

    it 'must serialize the bar' do
      assert_equal json, die.as_json
    end
  end
end