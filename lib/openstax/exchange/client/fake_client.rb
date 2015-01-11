require 'securerandom'

module OpenStax
  module Exchange
    module Client
      class FakeClient < Client
        def self.configure
          yield configuration
        end

        def self.configuration
          @configuration ||= Configuration.new
        end

        class Configuration
          attr_accessor :platform_id
          attr_accessor :platform_secret
          attr_accessor :registered_platforms
        end

        def initialize
          @platform_id          = self.class.configuration.platform_id
          @platform_secret      = self.class.configuration.platform_secret
          @registered_platforms = self.class.configuration.registered_platforms

          raise "invalid platform credentials" \
            unless @registered_platforms.fetch(@platform_id) == @platform_secret

          @token = SecureRandom.hex(64)
        end

        def is_real?
          false
        end

        def token
          @token
        end

        def create_identifier
          SecureRandom.hex(64)
        end
      end
    end
  end
end
