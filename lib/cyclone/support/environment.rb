require 'singleton'
module Cyclone
  module Support
    module Environment
      class Configuration < OpenStruct
	include Singleton
      end

      attr_accessor :environment
      def env
	@environment ||= Configuration.instance
      end
    end
  end
end
