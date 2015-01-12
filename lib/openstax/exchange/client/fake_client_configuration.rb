module OpenStax
  module Exchange
    module Client

      class FakeClientConfiguration
        attr_accessor :registered_platforms
        attr_accessor :server_base_url
        attr_accessor :server_port
        attr_accessor :supported_api_versions
      end

    end
  end
end