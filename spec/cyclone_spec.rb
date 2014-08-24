require 'spec_helper'

# class ProducerActor
#   def update(env={})
#     logger.debug "--- producer pushing msg..."
#     logger.debug env[:queue].push(:hello)
#     p env
#     env
#   end
# end
# 
# class ConsumerActor
#   def update(env={})
#     logger.debug "--- consumer popping queue..."
#     logger.debug env[:queue].pop
#     p env
#     env
#   end
# end
# 
# class ConsumerFactory < Cyclone::Factory
#   uses ConsumerActor
# end
# 
# class ConsumerProcess < Cyclone::Process
#   uses ConsumerFactory
# end
# 
# class ProducerFactory < Cyclone::Factory
#   uses ProducerActor
# end
# 
# class ProducerProcess < Cyclone::Process
#   uses ProducerFactory
# end
# 
# class QueuingAssembly < Cyclone::Assembly
#   uses ConsumerProcess, ProducerProcess
#   # def initialize
#   #   super(ConsumerProcess.new, ProducerProcess.new)
#   # end
# 
#   def on_step(environment={})
#     environment[:flip] = !environment[:flip]
#     environment
#   end
# end
# 
# describe Cyclone::Assembly do
#   subject do
#     QueuingAssembly.new
#   end
# 
#   let(:env) { subject.context }
# 
#   it 'should be awesome' do
#     env[:flip].should eql(nil)
#     subject.step
#     p subject.entities
#     env[:flip].should eql(true)
#   end
# end

