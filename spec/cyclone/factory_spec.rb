require 'spec_helper'

describe Factory do
  context 'hash factory' do 
    subject { HashFactory.new }
    it 'should assemble entities of the intended type' do
      subject.build.should be_a(Hash)
    end

    let(:object) { subject.build }

    it 'should invoke pre/postconstruct blocks' do
      object[:bar].should eql(0)
      # subject.build()[:bar].should eql(0)
      # subject.build[:foo].should eql(0)
    end
  end

  context 'open struct factory' do
    subject { OpenStructFactory.new }
    it 'should assemble entities of the intended type' do
      subject.build.should be_a(OpenStruct)
    end

    it 'should invoke pre/postconstruct blocks' do
      subject.build.foo.should eql(123)
      subject.build.bar.should eql('rainbow')
    end 
  end
end


