require 'openstax/exchange/version'

require 'oauth2'
require 'uri'
require 'json'

module OpenStax
  module Exchange

    DEFAULT_API_VERSION = :v1

    class << self

      ###########################################################################
      #
      # Configuration machinery.
      #
      # To configure OpenStax Exchange, put the following code in your
      # application's initialization logic
      # (eg. in the config/initializers in a Rails app)
      #
      #   OpenStax::Exchange.configure do |config|
      #     config.<parameter name> = <parameter value>
      #     ...
      #   end
      #
      
      def configure
        yield configuration
      end

      def configuration
        @configuration ||= Configuration.new
      end

      class Configuration
        # openstax_exchange_url
        # Base URL for OpenStax Exchange
        attr_reader :openstax_exchange_url

        # openstax_exchange_platform_id
        # OAuth client_id received from OpenStax Exchange
        attr_accessor :openstax_exchange_platform_id

        # openstax_exchange_platform_secret
        # OAuth client_secret received from OpenStax Exchange
        attr_accessor :openstax_exchange_platform_secret

        def openstax_exchange_url=(url)
          url.gsub!(/https|http/,'https') if !(url =~ /localhost/)
          url = url + "/" if url[url.size-1] != '/'
          @openstax_exchange_url = url
        end

        def initialize
          @openstax_exchange_platform_id = 'SET ME!'
          @openstax_exchange_platform_secret = 'SET ME!'
          @openstax_exchange_url = 'https://exchange.openstax.org/'
          super
        end
      end

      # Executes an OpenStax Exchange API call, using the given HTTP method,
      # API url and request options.
      # Any options accepted by OAuth2 requests can be used, such as
      # :params, :body, :headers, etc, plus the :access_token option, which can
      # be used to manually specify an OAuth access token.
      # On failure, it can throw Faraday::ConnectionFailed for connection errors
      # or OAuth2::Error if Exchange returns an HTTP 400 error,
      # such as 422 Unprocessable Entity.
      # On success, returns an OAuth2::Response object.
      def api_call(http_method, url, options = {})
        version = options.delete(:api_version)
        unless version.blank?
          options[:headers] ||= {}
          options[:headers].merge!({
            'Accept' => "application/vnd.exchange.openstax.#{version.to_s}"
          })
        end

        token_string = options.delete(:access_token)
        token = token_string.blank? ? client.client_credentials.get_token :
                  OAuth2::AccessToken.new(client, token_string)

        api_url = URI.join(configuration.openstax_exchange_url, 'api/', url)

        token.request(http_method, api_url, options)
      end

      # Performs an Event search in the Exchange server.
      # Results are limited to Events created by this platform.
      # Takes a query parameter and an optional API version parameter.
      # API version currently defaults to :v1 (may change in the future).
      # On failure, throws an Exception, just like api_call.
      # On success, returns an OAuth2::Response object.
      def search_events(query, version = DEFAULT_API_VERSION)
        options = {:params => {:q => query},
                   :api_version => version}
        api_call(:get, 'events', options)
      end

      # Creates a new Identifier to represent an anonymous user.
      # Takes an optional API version parameter.
      # On success, returns a hash containing the identifier.
      def create_identifier(version = DEFAULT_API_VERSION)
        options = {:api_version => version}
        JSON.parse(api_call(:post, 'identifiers', options).body)
      end

      # Creates an Event that records the user submitting a multiple choice
      # answer.
      # Takes an Identifier to represent an anonymous user.
      # Takes optional attributes parameter and API version parameter.
      # On success, returns a hash containing multiple choice event information.
      def create_multiple_choice(identifier, attributes = {}, version = DEFAULT_API_VERSION)
        options = {:api_version => version,
          :body => attributes.to_json,
          :params => {:identifier => identifier}}
        res = api_call(:post, 'events/platforms/multiple_choices', options)
        JSON.parse(res.body)
      end

      # Creates an Event that records the user submitting a free response
      # answer.
      # Takes an Identifier to represent an anonymous user.
      # Takes optional attributes parameter and API version parameter.
      # On success, returns a hash containing free response event information.
      def create_free_response(identifier, attributes = {}, version = DEFAULT_API_VERSION)
        options = {:api_version => version,
          :body => attributes.to_json,
          :params => {:identifier => identifier}}
        res = api_call(:post, 'events/platforms/free_responses', options)
        JSON.parse(res.body)
      end

      # Creates an Event that records or updates a task assignment.
      # Takes an Identifier to represent an anonymous user.
      # Takes optional attributes parameter and API version parameter.
      # On success, returns a hash containing task event information.
      def create_task(identifier, attributes = {}, version = DEFAULT_API_VERSION)
        options = {:api_version => version,
          :body => attributes.to_json,
          :params => {:identifier => identifier}}
          res = api_call(:post, 'events/platforms/tasks', options)
          JSON.parse(res.body)
      end

      # Creates an Event that records a user's work being graded.
      # Takes an Identifier to represent the anonymous user that did the work.
      # Takes optional attributes parameter and API version parameter.
      # On success, returns
      def create_grading(identifier, attributes = {}, version = DEFAULT_API_VERSION)
        options = {:api_version => version,
          :body => attributes.to_json,
          :params => {:identifier => identifier}}
          res = api_call(:post, 'events/platforms/gradings', options)
          JSON.parse(res.body)
      end


      protected
      def client
        @client ||= OAuth2::Client.new(configuration.openstax_exchange_platform_id,
                      configuration.openstax_exchange_platform_secret,
                      :site => configuration.openstax_exchange_url)
      end

    end

  end
end
