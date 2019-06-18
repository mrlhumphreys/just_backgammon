require 'just_backgammon/common'

module JustBackgammon

  # = Die
  #
  # The die is a cube that be rolled to result in a number from 1 to 6.
  class Die
    extend Common

    # A new instance of Die.
    #
    # @param [Fixnum] id
    #   The identifier of the die.
    #
    # @param [Fixnum, NilClass] number
    #   The number of the die. Returns nil if not yet rolled.
    #
    # ==== Example:
    #   # Instantiates a new Die
    #   JustBackgammon::Die.new(id: 1, number: 1)
    def initialize(id: , number:)
      @id = id
      @number = number
    end

    # @return [Fixnum] the identifier of the die.
    attr_reader :id

    # @return [Fixnum] the number of the die. Returns nil if not yet rolled
    attr_reader :number

    # Rolls the die, the number will be between 1 and 6.
    #
    # @return [Fixnum]
    def roll
      @number = Random.new.rand(6) + 1
    end

    # Resets the die, the number will be nil.
    #
    # @return [NilClass]
    def reset
      @number = nil
    end

    # Equals operator compares the number to determine if the dice are equal.
    #
    # @return [Boolean]
    def == (other)
      self.number == other.number
    end

    # A hashed serialized representation of the die
    #
    # @return [Hash]
    def as_json
      { id: id, number: number }
    end
  end
end
