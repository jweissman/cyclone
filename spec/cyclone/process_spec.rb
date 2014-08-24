require 'spec_helper'

describe Cyclone::Process do
  subject do
    logger.debug "--- creating new flip flop process"
    FlipFlopProcess.new #({})
  end

  let(:collection) { subject.collection }
  let(:entity) { collection.sample } 

  before { subject.activate }
  after { subject.deactivate }

  it 'should wrap around a collection' do
    collection.should_not be_empty
    collection.resources.should be_a(Array)
  end

  it 'should update entities' do
    sleep 1
    # something to prove apply has been called and changed state somehow...
    entity.should_not be_nil
    p entity
    
  end

  # it 'should run after create filters' do
  #   subject.entities.should_not be_empty
  #   subject.entities.should be_a(Array)

  #   # subject.environment.should_not be_nil
  #   # subject.environment.should be_a(Hash)
  # end

  # it 'should update entities' do
  #   sleep 1
  #   foo = subject.entities.map { |e| e[:foo] }.mean
  #   bar = subject.entities.map { |e| e[:bar] }.mean
  #   [ foo, bar ].each { |i| i.should_not eql(0.0) }  
  # end

  # it 'should interact with the environment' do
  #   p subject
  #   subject.environment[:flip].should_not be_nil
  # end
end
