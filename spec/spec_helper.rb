require 'simplecov'
SimpleCov.start

require 'openstax/exchange/client'
require 'lib/openstax/exchange/client/shared_examples_for_exchange_client_v1'

API_VERSION_V1 = 'v1'

DEFAULT_CLIENT_PLATFORM_ID     = '123'
DEFAULT_CLIENT_PLATFORM_SECRET = 'abc'
DEFAULT_CLIENT_SERVER_BASE_URL = 'http://localhost'
DEFAULT_CLIENT_SERVER_PORT     = 3003
DEFAULT_CLIENT_API_VERSION     = API_VERSION_V1
