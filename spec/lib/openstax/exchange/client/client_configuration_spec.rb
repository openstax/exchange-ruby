require 'spec_helper'

describe OpenStax::Exchange::Client do

  before(:each) do
    OpenStax::Exchange::Client.configure do |config|
      config.platform_id     = DEFAULT_CLIENT_PLATFORM_ID
      config.platform_secret = DEFAULT_CLIENT_PLATFORM_SECRET
      config.server_base_url = DEFAULT_CLIENT_SERVER_BASE_URL
      config.server_port     = DEFAULT_CLIENT_SERVER_PORT
      config.api_version     = DEFAULT_CLIENT_API_VERSION
    end

    OpenStax::Exchange::Client::FakeClient.configure do |config|
      config.registered_platforms = {DEFAULT_CLIENT_PLATFORM_ID => DEFAULT_CLIENT_PLATFORM_SECRET}
    end
  end

  context "internal client instance" do
    it "#client defaults to a real exchange client" do
      client = OpenStax::Exchange::Client.send(:client)
      expect(client.is_real_client?).to be_truthy
    end

    it "#client returns the same client object on successive calls" do
      client_object_id1 = OpenStax::Exchange::Client.send(:client).object_id
      client_object_id2 = OpenStax::Exchange::Client.send(:client).object_id
      expect(client_object_id1).to eq(client_object_id2)
    end

    it "#clear_client causes a new client object to be returned by #client" do
      client_object_id1 = OpenStax::Exchange::Client.send(:client).object_id
      OpenStax::Exchange::Client.reset!
      client_object_id2 = OpenStax::Exchange::Client.send(:client).object_id
      expect(client_object_id1).to_not eq(client_object_id2)
    end
  end

  context "client instance configuration" do
    before(:each) do
      OpenStax::Exchange::Client.reset!
    end

    it "can be configured to use a real exchange client" do
      OpenStax::Exchange::Client.use_real_client
      client = OpenStax::Exchange::Client.send(:client)
      expect(client.is_real_client?).to be_truthy
    end

    it "can be configured to use a fake exchange client" do
      OpenStax::Exchange::Client.use_fake_client
      client = OpenStax::Exchange::Client.send(:client)
      expect(client.is_real_client?).to be_falsy
    end
  end

end
