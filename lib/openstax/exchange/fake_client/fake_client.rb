require 'securerandom'
require 'uri'

module OpenStax
  module Exchange

    class FakeClient
      include ClientInstance

      def self.configure
        yield configuration
      end

      def self.configuration
        @configuration ||= Configuration.new
      end

      def initialize(exchange_configuration)
        @client_config_platform_id     = exchange_configuration.client_platform_id
        @client_config_platform_secret = exchange_configuration.client_platform_secret
        @client_config_server_url      = exchange_configuration.client_server_url
        @client_config_api_version     = exchange_configuration.client_api_version

        @server_registered_platforms   = self.class.configuration.registered_platforms
        @server_server_url             = self.class.configuration.server_url

        raise "invalid server url" \
          unless @client_config_server_url == @server_server_url

        raise "invalid platform credentials" \
          unless @server_registered_platforms.fetch(@client_config_platform_id) == @client_config_platform_secret

        @token = SecureRandom.hex(64)
        @multiple_choice_responses = {}
      end

      def is_real_client?
        false
      end

      def token
        @token
      end

      def create_identifier
        {
          'read' => SecureRandom.hex(64),
          'write' => SecureRandom.hex(64)
        }
      end

      def record_multiple_choice_answer(identifier, resource, trial, answer)
        @multiple_choice_responses[identifier] ||= {}
        @multiple_choice_responses[identifier][resource] ||= {}

        raise "invalid resource" \
          unless URI(resource).host == "exercises-dev1.openstax.org"

        raise "duplicate response for (identifier,resource,trial) triplet" \
          if @multiple_choice_responses[identifier][resource][trial]

        @multiple_choice_responses[identifier][resource][trial] = answer

        return {
          'identifier' => identifier,
          'resource'   => resource,
          'trial'      => trial,
          'answer'     => answer
        }
      end
    end

  end
end
