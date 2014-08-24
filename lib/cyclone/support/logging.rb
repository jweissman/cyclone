require 'singleton'
module Cyclone
  module Support
    module Logging
      class Log
	include ::Singleton

	attr_accessor :logger, :tracer

	def initialize
	  @logger = create_logger_instance
	  #@tracer.enable
	end

	def create_logger_instance(name='development')
	  log = Logger.new("log/##{name}.log")
	  #log.level = Logger::TRACE 
	  #@tracer = create_tracer do |tp|
	  #  log.debug "#{tp.lineno} [#{tp.event}] {#{tp.raised_exception}}"
	  #end
	  log
	end

	def create_tracer
	  tracer = nil
	  # tracer = TracePoint.new(:raise) do |tp|
	  #   yield tp if block_given?
	  # end
	  tracer
	end
      end

      def active_log
	@log ||= Log.instance.logger
      end
      alias :logger :active_log

      def log(msg)
	active_log.debug(msg)
      end
    end
  end
end
