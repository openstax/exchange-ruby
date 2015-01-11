module OpenStax
  module Exchange
    module Client
      class ClientConfiguration
        attr_accessor :platform_id
        attr_accessor :platform_secret
        attr_accessor :server_base_url
        attr_accessor :api_version

        def initialize
          use_real_client
        end

        def use_real_client
          @use_real_client = true
        end

        def use_fake_client
          @use_real_client = false
        end

        def use_real_client?
          !!@use_real_client
        end

        def use_fake_client?
          !use_real_client?
        end
      end
    end
  end
end