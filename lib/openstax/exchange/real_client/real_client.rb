require 'oauth2'

module OpenStax
  module Exchange

    class RealClient
      include ClientInstance

      def initialize(exchange_configuration)
        @platform_id     = exchange_configuration.client_platform_id
        @platform_secret = exchange_configuration.client_platform_secret
        @server_base_url = exchange_configuration.client_server_base_url
        @server_port     = exchange_configuration.client_server_port
        @api_version     = exchange_configuration.client_api_version

        @server_base = "#{@server_base_url}:#{@server_port}"

        @oauth_client = OAuth2::Client.new(
          @platform_id,
          @platform_secret,
          site: @server_base)

        @oauth_token = @oauth_client.client_credentials.get_token
      end

      def is_real_client?
        true
      end

      def token
        @oauth_token.token
      end

      def create_identifier
        options = {}
        add_accept_header! options

        response = @oauth_token.request(
          :post,
          "#{@server_base}/api/identifiers",
          options)

        return JSON.parse(response.body)['identifier']
      end

      def record_multiple_choice_answer(identifier, resource, trial, answer)
        options = {}
        add_accept_header! options
        add_authorization_header! options

        options[:body] = { identifier: identifier, resource: resource, trial: trial, answer: answer }.to_json

        response = @oauth_token.request(
          :post,
          "#{@server_base}/api/events/platforms/multiple_choices",
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
