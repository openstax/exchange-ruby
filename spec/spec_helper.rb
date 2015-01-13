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

require 'openstax_exchange'
require 'lib/openstax/exchange/shared_examples_for_exchange_client_v1'

API_VERSION_V1 = 'v1'

DEFAULT_CLIENT_PLATFORM_ID     = '123'
DEFAULT_CLIENT_PLATFORM_SECRET = 'abc'
DEFAULT_CLIENT_SERVER_SCHEME   = 'http'
DEFAULT_CLIENT_SERVER_HOST     = 'localhost'
DEFAULT_CLIENT_SERVER_PORT     = 3003
DEFAULT_CLIENT_SERVER_PATH     = nil
DEFAULT_CLIENT_API_VERSION     = API_VERSION_V1

def client_server_url(options = {})
  server_scheme = options.fetch(:scheme) { DEFAULT_CLIENT_SERVER_SCHEME }
  server_host   = options.fetch(:host)   { DEFAULT_CLIENT_SERVER_HOST }
  server_port   = options.fetch(:port)   { DEFAULT_CLIENT_SERVER_PORT }
  server_path   = options.fetch(:path)   { DEFAULT_CLIENT_SERVER_PATH }

  url = URI::Generic.build(
    scheme: server_scheme,
    host:   server_host,
    port:   server_port,
    path:   server_path)

  url.to_s
end
