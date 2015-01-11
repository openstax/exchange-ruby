require 'oauth2'

module OpenStax
  module Exchange
    module Client
      class RealClient < Client
        def self.configure
          yield configuration
        end

        def self.configuration
          @configuration ||= Configuration.new
        end

        class Configuration
          attr_accessor :platform_id
          attr_accessor :platform_secret
          attr_accessor :server_base_url
          attr_accessor :api_version
        end

        def is_real?
          true
        end

        def initialize
          @platform_id     = self.class.configuration.platform_id
          @platform_secret = self.class.configuration.platform_secret
          @server_base_url = self.class.configuration.server_base_url
          @api_version     = self.class.configuration.api_version

          @oauth_client = OAuth2::Client.new(
            @platform_id,
            @platform_secret,
            site: @server_base_url)

          @oauth_token = @oauth_client.client_credentials.get_token
        end

        def token
          @oauth_token.token
        end

        def create_identifier
          options = {}
          add_accept_header! options

          response = @oauth_token.request(
            :post,
            "#{@server_base_url}/api/identifiers",
            options)

          return JSON.parse(response.body)['identifier']
        end

        def create_multiple_choice(identifier, resource, trial, answer)
          options = {}
          add_accept_header! options
          add_authorization_header! options

          options[:body] = { identifier: identifier, resource: resource, trial: trial, answer: answer }.to_json

          response = @oauth_token.request(
            :post,
            "#{@server_base_url}/api/events/platforms/multiple_choices",
            options)

          return JSON.parse(response.body)
        end

        private

        def add_header_hash!(options)
          options[:headers] = {} unless options.has_key? :headers
        end

        def add_accept_header!(options)
          add_header_hash! options
          options[:headers].merge!({ 'Accept' => "application/vnd.exchange.openstax.#{@api_version}" })
        end

        def add_authorization_header!(options)
          add_header_hash! options
          options[:headers].merge!({ 'Authorization' => "Bearer #{token}" })
        end

      end
    end
  end
end
