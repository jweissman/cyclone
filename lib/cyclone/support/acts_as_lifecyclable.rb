module Cyclone
  module Support
    module ActsAsLifecyclable
      def self.included(base)
	base.send :extend, Cyclone::Support::MethodDispatching::ClassMethods
	base.send :extend, ClassMethods
      end

      module Constants
	PHASES = %w[ before after around ]
      end

      module InstanceMethods
	include Cyclone::Support::Logging
	def process_filter_chain(chain=[], value)
	  logger.info "=== #{self.class}#process_filter_chain (chain=#{chain}, args=#{value})"
	  ret_value = value

	  if chain.is_a?(Proc)
	    ret_value = chain.call(ret_value)
	    return ret_value
	  end

	  chain.each do |filter|
	    if filter.is_a?(Proc)
	      ret_value = filter.call(ret_value)
	    elsif filter.is_a?(Symbol)
	      ret_value = send(filter, ret_value)
	    else
	      raise "unknown filter type #{filter}"
	    end

	    ret_value
	  end

	  ret_value
	end
      end

      module ClassMethods
	include Constants
	include Cyclone::Support::Logging

	attr_reader :filters
	def filters
	  @filters ||= Hash.new
	end

	def acts_as_lifecyclable(*events)
	  logger.debug "=== Preparing #{self} to act as lifecyclable"
	  acts_as_method_dispatching
	  send :include, Cyclone::Support::ActsAsLifecyclable::InstanceMethods
	  events.each do |event|
	    self.send(:prepend, event_filtration_module(event))
	    define_filtration_methods(event)
	  end
	  logger.debug "=== #{self} acts as lifecyclable!"
	end

	def add_filter_hook(prefix, event, hook)
	  self.filters[prefix] ||= {}
	  self.filters[prefix][event] ||= []
	  self.filters[prefix][event] << hook
	end

	def define_filtration_methods(event)
	  PHASES.each do |phase|
	    define_singleton_method "#{phase}_#{event}" do |*syms, &blk|
	      logger.info ">>> #{phase} #{event} defined!" # with #{syms || blk}" 
	      syms.each { |hook| add_filter_hook(phase.to_sym, event, hook) }
	      add_filter_hook(phase.to_sym, event, blk) if blk
	    end
	  end
	end

	def event_filtration_module(event)
	  Module.new do
	    def filters_for(prefix, event)
	      self.class.filters[prefix] ||= {}
	      self.class.filters[prefix][event]
	    end

	    def run_filters_for(prefix, event, chain_value)
	      logger.debug "=== EventFiltration#run_filters_for (event=#{event}, prefix=#{prefix}, args=#{chain_value})"
	      event_filters = filters_for(prefix, event)
	      logger.debug "--- Filters for #{event} #{prefix} => #{event_filters}"


	      unless event_filters #.empty?
		logger.debug "++++ FILTERS ARE EMPTY ++++"
		# have to handle yielding with some default behavior
		# since there won't be a yield in the chain, since there's no chain! :)
		if block_given?
		  logger.debug "--- BUT BLOCK GIVEN!!!!"
		  logger.debug "--- yielding with args #{chain_value}"
		  chain_value = yield(chain_value)
		end
	      end

	      return chain_value if event_filters.nil?
	      process_filter_chain(event_filters, chain_value)
	    end
	    alias :filter :run_filters_for

	    eval <<-ruby
	      def #{event}(args=nil)
	        run_filters_for(:around, :#{event}, args) do |chain_value|
		  before_result = run_filters_for(:before, :#{event}, args)
		  super_result = super(before_result)
		  run_filters_for(:after, :#{event}, super_result)
		end
	      end
	    ruby
	  end
	end
      end
    end
  end
end
