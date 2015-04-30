require 'oauth2'
require 'hashie'

module OpenStax
  module Exchange

    class RealClient
      include ClientInstance

      def initialize(exchange_configuration)
        @platform_id     = exchange_configuration.client_platform_id
        @platform_secret = exchange_configuration.client_platform_secret
        @server_url      = exchange_configuration.client_server_url
        @api_version     = exchange_configuration.client_api_version

        @oauth_client = OAuth2::Client.new(
          @platform_id,
          @platform_secret,
          site: @server_url)

        @oauth_token = @oauth_client.client_credentials.get_token
      end

      def is_real_client?
        true
      end

      def token
        @oauth_token.token
      end

      def create_identifiers
        options = {}
        add_accept_header! options
        add_content_type_header! options

        response = @oauth_token.request(
          :post,
          "#{@server_url}/api/identifiers",
          options
        )

        return Hashie::Mash.new(JSON.parse(response.body))
      end

      def record_multiple_choice_answer(identifier, resource, trial, answer)
        options = {}
        add_accept_header! options
        add_authorization_header! options
        add_content_type_header! options

        options[:body] = { identifier: identifier, resource: resource, trial: trial, answer: answer }.to_json

        response = @oauth_token.request(
          :post,
          "#{@server_url}/api/events/platforms/multiple_choices",
          options
        )

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

      def add_content_type_header!(options)
        add_header_hash! options
        options[:headers].merge!({ 'Content-Type' => "application/json" })
      end
    end

  end
end
