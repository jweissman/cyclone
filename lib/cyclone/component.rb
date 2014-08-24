module Cyclone
  # kind of has a bunch of supporting logic -- too much?
  # it would be nice to refactor into modules
  class Component
    include Cyclone::Support::Logging
    include Cyclone::Support::ActsAsLifecyclable
    include Cyclone::Support::ActsAsTyped
    include Cyclone::Support::Environment

    acts_as_lifecyclable :activate, :step, :tick, :halt

    def activate(ignored=nil)
      logger.debug 'activate'
      @thread = background_thread
      env.active = true
    end

    def background_thread
      Thread.new do 
	loop { step! }  
      end
    end

    def step
      logger.warn "you should implement #step in a subclass of component (intended to be abstract...)"
    end

    def deactivate
      unless @thread
	logger.warn 'cannot deactivate component if not yet activated' 
	return 
      end
      Thread.kill(@thread)
      env.active = false
    end
  end
end
