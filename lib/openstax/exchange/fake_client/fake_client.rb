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

      def initialize(client_configuration)
        @client_config_platform_id          = client_configuration.platform_id
        @client_config_platform_secret      = client_configuration.platform_secret
        @client_config_server_base_url      = client_configuration.server_base_url
        @client_config_server_port          = client_configuration.server_port
        @client_config_api_version          = client_configuration.api_version

        @server_registered_platforms = self.class.configuration.registered_platforms
        @server_server_base_url      = self.class.configuration.server_base_url
        @server_server_port          = self.class.configuration.server_port

        raise "invalid server" \
          unless @client_config_server_base_url == @server_server_base_url

        raise "invalid port" \
          unless @client_config_server_port == @server_server_port

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
        SecureRandom.hex(64)
      end

      def create_multiple_choice(identifier, resource, trial, answer)
        @multiple_choice_responses[identifier] ||= {}
        @multiple_choice_responses[identifier][resource] ||= {}

        raise "invalid resource" \
          unless URI(resource).host == "exercises.openstax.org"

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
