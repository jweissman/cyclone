class FlipFlopProcess < Cyclone::Process
  uses Hash
  #

  # before_step :blarg
  # def blarg
  #   logger.debug "==== BLARG"
  # end
  # def flip(entity, env={})
  #   # logger.debug "=== FLIP"
  #   env[:flip] = !env[:flip]
  #   env
  # end
  # before_tick :flip

  def perform(hash, env={})
    logger.info "=== FLIP FLOP PROCESS PERFORM"
    env[:flip] = !env[:flip]
    key = env[:flip] ? :foo : :bar
    hash[key] = (hash[key]||0) + rand*(rand>0.5 ? -1 : 1)
    hash
  end
end


