require 'spec_helper'

describe OpenStax::Exchange::FakeClient do
  before(:each) do
    OpenStax::Exchange.use_fake_client
    OpenStax::Exchange::FakeClient.configure do |config|
      config.registered_platforms   = {DEFAULT_CLIENT_PLATFORM_ID => DEFAULT_CLIENT_PLATFORM_SECRET}
      config.server_base_url        = DEFAULT_CLIENT_SERVER_BASE_URL
      config.server_port            = DEFAULT_CLIENT_SERVER_PORT
      config.supported_api_versions = [API_VERSION_V1]
    end
  end

  it_behaves_like "exchange client api v1"
end
