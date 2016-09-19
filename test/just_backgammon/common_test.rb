require "test_helper"

class LoremIpsum
  extend JustBackgammon::Common
  def initialize(args)
    @args = args
  end
  
  attr_reader :args
end

describe JustBackgammon::Common do
  let(:loaded_object) { LoremIpsum.load(argument) }
  
  describe 'loading a hash' do
    let(:argument) { { hello: 'world' } }
    
    it 'must return an instance of the class' do
      assert_instance_of(LoremIpsum, loaded_object)
    end
  end
  
  describe 'loading an object of the class' do
    let(:argument) { LoremIpsum.new(hello: 'world') }
    
    it 'must return the object' do
      assert_equal(loaded_object, argument)
    end
  end
  
  describe 'loading an object not of the class' do
    let(:argument) { 3 }
    
    it 'must raise an argument error' do
      assert_raises(ArgumentError) { loaded_object }
    end
  end
  
  describe 'loading an array of hashes' do
    let(:argument) { [{ hello: 'world' }] }
    
    it 'must return an array of objects of the class' do
      assert(loaded_object.all? { |o| o.instance_of?(LoremIpsum) })
    end
  end
  
  describe 'loading an array of objects of the class' do
    let(:argument) { [LoremIpsum.new(hello: 'world')] }
    
    it 'must return the array of objects of the class' do
      assert_equal(loaded_object, argument)
    end
  end
  
  describe 'loading an array of objects not of the class' do
    let(:argument) { [3] }
    
    it 'must raise an argument error' do
      assert_raises(ArgumentError) { loaded_object }
    end
  end
end