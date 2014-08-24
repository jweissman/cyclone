require 'spec_helper'

class Student < OpenStruct
  attr_accessor :gender
  def to_s; "#{gender ? 'male' : 'female'} student" end 
end

class StudentFactory < Factory
  uses Student
  after_build do |student| 
    student.gender = [:male,:female].sample
    student
  end
end

describe Collection do
  let(:factory) { StudentFactory.new }
  let(:opts) {{initial_size: 100}}
  subject { Collection.new(factory, opts) }
  let(:resources) { subject.resources }
  it 'should build a collection of entities' do
    resources.should be_an(Array)
    resources.should_not be_nil
    entity = resources.first
    entity.should be_a(Student)
  end
end
