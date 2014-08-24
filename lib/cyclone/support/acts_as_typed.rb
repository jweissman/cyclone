module Cyclone
  module Support
    # n.b., we don't assume much about the type; could be a sym or a class or whatev
    module ActsAsTyped
      def self.included(base)
	base.send :extend, ClassMethods
      end

      module InstanceMethods
	def create_new_entity_of_given_type
	  entity = klass.new 
	  logger.info "--- creating entity of type #{klass}: #{entity}"
	  entity
	end
	
	def matches_type?(entity)
	  entity.class == klass
	end
      end

      module ClassMethods
	#attr_accessor :explicit_type
	def acts_as_typed(type)
	  # @@explicit_type = type
	  send :include, InstanceMethods
	  define_method(:klass) { type } # j @@explicit_type }
	  logger.debug "=== #{self} acts as typed (#{type})!"
	  self
	end
	alias :uses :acts_as_typed
      end
    end
  end
end
