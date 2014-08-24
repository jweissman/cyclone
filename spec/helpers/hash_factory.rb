class HashFactory < Cyclone::Factory
  uses Hash

  after_build :set_foo, :set_bar

  def set_foo(entity={}) #attrs={})
    logger.debug "=== HashFactory#set_foo (entity=#{entity})"
    entity[:foo] = 0
    entity 
  end

  def set_bar(entity={})
    logger.debug "=== HashFactory#set_bar (entity=#{entity})"
    entity[:bar] = 0
    entity
  end
end
