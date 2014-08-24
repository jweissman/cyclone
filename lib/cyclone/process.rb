module Cyclone
  #
  # A process wraps a component around a collection (possibly models)
  # and a threaded execution context for applying processing over them 
  #
  class Process < Component
    extend Forwardable

    DEFAULT_POPULATION = 50
    DEFAULT_CADENCE = 2 ** 4

    attr_accessor :collection
    def_delegators :@collection, :size, :<<, :map, :sample

    def initialize(resources=[], opts={})
      @initial_size = opts.delete(:initial_size) { DEFAULT_POPULATION }
      @factory      = opts.delete(:factory) { Factory.uses(klass).new }
      @cadence      = opts.delete(:cadence) { DEFAULT_CADENCE }

      @collection   = Cyclone::Collection.new(@factory, initial_size: @initial_size)
    end

    def tick
      @cadence.times { @collection = apply }
      @collection
    end
    
    def perform(item)# env)
      raise "you should define #perform in a subclass of process (intended to be abstract..)"
      # [item] #, env]
    end

    private
    def apply
      @collection.map(&method(:perform))
      # @collection.map { |e| perform(e,env) }
    end
  end
end
