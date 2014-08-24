module Cyclone
  class Factory < Component
    include Cyclone::Support::ActsAsTyped
    acts_as_lifecyclable :build
    def build(attributes={})
      logger.debug "==== Factory[#{self.class}]#build (type=#{klass})"
      entity = create_new_entity_of_given_type
      send_attribute_updates(entity, attributes)
      entity
    end
  end
end
