module JustBackgammon

  # = Common
  #
  # Mixin that allows the class to have a custom load method
  # It allows initializing by arrays, hashes or objects with the same class.
  module Common

    # Method that initializing an object by arrays, hashes or objects with the same class.
    # Returns the object or array of objects.
    # Will raise error if elements of array are not all the same Class.
    # Will raise error if argument is not Hash, Array or the same Class.
    #
    # @param [Array<Hash>, Hash, Object] argument
    #   The initialization data.
    #
    # @return [Array<Object>, Object]
    def load(argument)
      case argument
      when Hash
        self.new(**argument)
      when Array
        case
        when argument.all? { |o| o.instance_of?(Hash) }
          argument.map { |o| self.new(**o) }
        when argument.all? { |o| o.instance_of?(self) }
          argument
        else
          raise ArgumentError, "elements of array must have the same class"
        end
      when self
        argument
      else
        raise ArgumentError, "argument needs to be a Hash, Array or #{self}"
      end
    end
  end
end
