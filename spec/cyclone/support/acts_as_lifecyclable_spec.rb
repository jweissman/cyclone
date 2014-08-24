require 'spec_helper'
class QuuxingWidget 
  include Cyclone::Support::ActsAsLifecyclable
  acts_as_lifecyclable :quux

  def quux(value=1)
    logger.debug "=== Widget#quux called with #{value}"
    4 * value
  end
end

class BuzzingWidget < QuuxingWidget
  before_quux do |value|
  # def buzz(value=1)
    logger.debug "=== BuzzingWidget#buzz (val=#{value})"
    value * 8
  end
end

class BazzingWidget < QuuxingWidget
  before_quux :bizz
  after_quux :bazz

  def bizz(value=1)
    logger.debug "--- BazzingWidget#bizz (val=#{value})"
    value * 2
  end

  def bazz(value=1)
    logger.debug "--- BazzingWidget#bazz (val=#{value})"
    value * 3
  end
end

# TODO think about this pattern, really very noisy...
class FliskingWidget < QuuxingWidget
  around_quux :flisk
  def flisk(value=1)
    logger.debug "=== FliskingWidget#flisk (val=#{value})"
    return_value = value * 9
    logger.debug "--- about to yield..."
    if block_given?
      return_value = yield(return_value) 
    end
    return_value * 8
  end
end

describe Cyclone::Support::ActsAsLifecyclable do
  context "filters" do
    context "#before" do 
      subject { BuzzingWidget.new }
      it 'should call before filters' do
	subject.quux(10).should eql 320
      end
    end

    context "#after" do 
      subject { BazzingWidget.new }
      it 'should call after filters' do
	subject.quux(8).should eql 192
      end
    end
    
    context "#around" do
      subject { FliskingWidget.new }
      it 'should call around filters' do
	subject.quux(10).should eql 720
      end
    end
  end
end
