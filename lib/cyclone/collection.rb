module Cyclone
  class Collection
    attr_accessor :factory
    attr_reader :resources

    include Cyclone::Support::ActsAsLifecyclable
    acts_as_lifecyclable :assemble, :add, :remove
    extend Forwardable
    def_delegators :@resources, :size, :<<, :map, :sample, :empty?

    def initialize(factory, opts={})
      logger.debug "--- create new collection"
      @initial_size = opts.delete(:initial_size) { 30  }
      @factory = factory
      @initial_attributes  = opts.delete(:attributes) { {} }
      @resources = Array.new(@initial_size) { assemble(@initial_attributes) }
    end

    def assemble(attributes={})
      factory.build(attributes)
    end

    def apply(*args,&fn)
      map { |e| fn.call(e,*args) }
    end
  end
end
