require 'simplecov'
SimpleCov.start

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  # c.debug_logger = File.open("vcr_log.txt", "w")
end

accept_header = lambda do |request1, request2|
  request1.headers['Accept'] == request2.headers['Accept']
end

authorization_header = lambda do |request1, request2|
  request1.headers['Authorization'] == request2.headers['Authorization']
end

VCR_OPTS = {
  record: :none, ## this should be :none before pushing
  allow_unused_http_interactions: false,
  match_requests_on: [:method, :uri, :host, :body, accept_header, authorization_header]
}

require 'openstax/exchange/client'
require 'lib/openstax/exchange/client/shared_examples_for_exchange_client_v1'

API_VERSION_V1 = 'v1'

DEFAULT_CLIENT_PLATFORM_ID     = '123'
DEFAULT_CLIENT_PLATFORM_SECRET = 'abc'
DEFAULT_CLIENT_SERVER_BASE_URL = 'http://localhost'
DEFAULT_CLIENT_SERVER_PORT     = 3003
DEFAULT_CLIENT_API_VERSION     = API_VERSION_V1
