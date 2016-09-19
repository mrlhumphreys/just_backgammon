require 'just_backgammon/common'
require 'just_backgammon/die'

module JustBackgammon

  # = DiceSet
  #
  # The collections of dice.
  class DiceSet
    extend Common
    extend Forwardable

    # A new instance of DiceSet.
    #
    # @param [Array<Hash>] dice
    #   All the dice in the set, each with a number.
    #
    # ==== Example:
    #   # Instantiates a new DiceSet
    #   JustBackgammon::DiceSet.new({
    #     dice: [{number: 1}, {number: 2}]
    #   })
    def initialize(dice:)
      @dice = Die.load(dice)
    end

    # @return [Array<Dice>] allthe dice in the set, each with a number
    attr_reader :dice

    def_delegator :dice, :map
    def_delegator :dice, :each

    # finds a die that matches the specified number.
    #
    # @return [Die]
    def find_by_number(number)
      @dice.find { |d| d.number == number }
    end

    # returns an array of the numbers on the dice.
    #
    # @return [Array<Fixnum>]
    def numbers
      @dice.map(&:number)
    end

    # randomizes each die and duplicates if they are the same number.
    #
    # @return [Array<Die>]
    def roll
      @dice.each(&:roll)
      if @dice.first == @dice.last
        @dice.concat(@dice)
      end
    end

    # sets all dice numbers to nil and reduces the number of dice to two.
    #
    # @return [Array<Die>]
    def reset
      @dice.each(&:reset)
      if @dice.size > 2
        @dice.slice!(-2..-1)
      end
    end

    # A hashed serialized representation of the dice set.
    #
    # @return [Hash]
    def as_json
      dice.map(&:as_json)
    end
  end
end