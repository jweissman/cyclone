module Cyclone
  module Support
    module MethodDispatching
      def self.included(base)
	base.send :extend, ClassMethods
      end

      module ClassMethods
	def acts_as_method_dispatching
	  send :include, InstanceMethods
	end
      end

      module InstanceMethods
	def dispatch(syms=[], *args, &blk) 
	  logger.debug "--- dispatching #{syms}"
	  syms.map(&method(:send, *args, &blk))
	end

	def update_attributes(object, attributes={})
	  send_attribute_updates(object.clone, attributes)
	end

	def send_attribute_updates(object, attributes={})
	  return unless attributes
	  # logger.debug "--- update with attributes #{attributes}"
	  attributes.each { |k,v| object.send("#{k}=", v) }
	  object
	end
      end
    end
  end
end
