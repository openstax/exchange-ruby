require 'securerandom'

module OpenStax
  module Exchange
    module Client
      class FakeClient < ClientInstanceBase
        def self.configure
          yield configuration
        end

        def self.configuration
          @configuration ||= FakeClientConfiguration.new
        end

        def initialize(client_configuration)
          @client_config_platform_id          = client_configuration.platform_id
          @client_config_platform_secret      = client_configuration.platform_secret
          @client_config_server_url           = client_configuration.server_base_url
          @client_config_api_version          = client_configuration.api_version

          @registered_platforms = self.class.configuration.registered_platforms

          raise "invalid platform credentials" \
            unless @registered_platforms.fetch(@client_config_platform_id) == @client_config_platform_secret

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
