require 'spec_helper'

describe OpenStax::Exchange, vcr: VCR_OPTS do

  before(:each) do
    OpenStax::Exchange.configure do |config|
      config.client_platform_id     = DEFAULT_CLIENT_PLATFORM_ID
      config.client_platform_secret = DEFAULT_CLIENT_PLATFORM_SECRET
      config.client_server_url      = client_server_url
      config.client_api_version     = DEFAULT_CLIENT_API_VERSION
    end

    OpenStax::Exchange::FakeClient.configure do |config|
      config.registered_platforms   = {DEFAULT_CLIENT_PLATFORM_ID => DEFAULT_CLIENT_PLATFORM_SECRET}
      config.server_url             = client_server_url
      config.supported_api_versions = [ DEFAULT_CLIENT_API_VERSION ]
    end
  end

  context "internal client instance" do
    it "#client defaults to a real exchange client" do
      client = OpenStax::Exchange.send(:client)
      expect(client.is_real_client?).to be_truthy
    end

    it "#client returns the same client object on successive calls" do
      client_object_id1 = OpenStax::Exchange.send(:client).object_id
      client_object_id2 = OpenStax::Exchange.send(:client).object_id
      expect(client_object_id1).to eq(client_object_id2)
    end

    it "#reset! causes a new client object to be returned by #client" do
      client_object_id1 = OpenStax::Exchange.send(:client).object_id
      OpenStax::Exchange.reset!
      client_object_id2 = OpenStax::Exchange.send(:client).object_id
      expect(client_object_id1).to_not eq(client_object_id2)
    end
  end

  context "client instance configuration" do
    before(:each) do
      OpenStax::Exchange.reset!
    end

    it "can be configured to use a real exchange client" do
      OpenStax::Exchange.use_real_client
      client = OpenStax::Exchange.send(:client)
      expect(client.is_real_client?).to be_truthy
    end

    it "can be configured to use a fake exchange client" do
      OpenStax::Exchange.use_fake_client
      client = OpenStax::Exchange.send(:client)
      expect(client.is_real_client?).to be_falsy
    end
  end

end
