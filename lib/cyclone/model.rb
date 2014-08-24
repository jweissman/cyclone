module Cyclone
  class Model
    include Cyclone::Support::ActsAsLifecyclable
    acts_as_lifecyclable :create, :read, :update, :destroy

    def self.create(attributes={}, *keys_to_extract)
      logger.debug "=== CREATE attrs=#{attributes}"
      unless keys_to_extract.empty?
	attributes = extract_subhash(attributes, *keys_to_extract)
      end

      # grab a new entity and handle filters manually since
      # we are a class method and we don't have explicit support...
      entity = new

      new.filter :create do
	entity = entity.send_attribute_updates(entity, attributes)
      end
    end

    def read
      # filter :read do; self end
      self
    end

    def update(attributes={})	
      self.clone.update!(attributes)
    end

    def update!(attributes={})
      filter :update do
	send_attribute_updates(self, attributes)
      end
      self
    end

    def destroy
      filter :destroy do
	logger.debug "--- destroy is a no-op without a persistence layer, but you could hook or override with filters!"
      end
      nil
    end
  end
end
