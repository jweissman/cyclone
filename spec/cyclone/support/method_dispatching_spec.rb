require 'spec_helper'
require 'pry'
  
class MethodDispatchingEntity
  include Cyclone::Support::MethodDispatching
  acts_as_method_dispatching
end

# class FilterableEntity < OpenStruct
#   include Cyclone::Support::ActsAsFiltered
#   acts_as_filtered
# end
# 
# class HashInitializedEntity < OpenStruct
#   include Cyclone::Support::ActsAsFiltered
#   acts_as_filtered
# 
#   after_create :set_height_and_weight
#   attr_reader :weight, :height
#   def set_height_and_weight
#     logger.debug "=== SET HEIGHT AND WEIGHT"
#     @height = "5'4"
#     @weight = 180
#   end
# end

describe Cyclone::Support::MethodDispatching do
  let(:attributes) { {foo: 'baz', bar: 'quux'} }
  let(:empty_struct) { OpenStruct.new }

  context 'method dispatcher' do
    subject { MethodDispatchingEntity.new }
    let(:updated_object) { subject.update_attributes(empty_struct, attributes) }
    it 'should update objects' do
      updated_object.foo.should eql('baz')
      updated_object.bar.should eql('quux')
    end
  end

  # context 'lifecycle' do
  #   subject { FilterableEntity.create }
  #   it 'should update itself' do
  #     updated = subject.update(attributes)
  #     updated.foo.should eql('baz')
  #     updated.bar.should eql('quux')
  #   end
 
  #   it 'should update itself destructively' do
  #     subject.update!(attributes)
  #     subject.foo.should eql('baz')
  #     subject.bar.should eql('quux')
  #   end
  # end

  # context 'hash initialization' do
  #   subject { HashInitializedEntity.create(attributes) }
  #   
  #   it 'should initialize attributes' do
  #     subject.foo.should eql('baz')
  #     subject.bar.should eql('quux')
  #   end

  #   it 'should call after-create callbacks' do
  #     subject.height.should eql("5'4")
  #     subject.weight.should eql(180)
  #   end
  # end
end
