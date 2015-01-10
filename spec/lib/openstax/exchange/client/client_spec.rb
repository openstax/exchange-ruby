require 'spec_helper'

describe OpenStax::Exchange::Client do
  context "internal client instance" do
    it "#client defaults to a real exchange client" do
      client = OpenStax::Exchange::Client.send(:client)
      expect(client.is_real?).to be_truthy
    end

    it "#client returns the same client object on successive calls" do
      client_object_id1 = OpenStax::Exchange::Client.send(:client).object_id
      client_object_id2 = OpenStax::Exchange::Client.send(:client).object_id
      expect(client_object_id1).to eq(client_object_id2)
    end

    it "#clear_client causes a new client object to be returned by #client" do
      client_object_id1 = OpenStax::Exchange::Client.send(:client).object_id
      OpenStax::Exchange::Client.clear_client
      client_object_id2 = OpenStax::Exchange::Client.send(:client).object_id
      expect(client_object_id1).to_not eq(client_object_id2)
    end
  end

  context "client configuration" do
    before(:each) do
      OpenStax::Exchange::Client.clear_client
    end

    it "can be configured to use a real exchange client" do
      OpenStax::Exchange::Client.configure do |config|
        config.use_real_client
      end
      client = OpenStax::Exchange::Client.send(:client)
      expect(client.is_real?).to be_truthy
    end

    it "can be configured to use a fake exchange client" do
      OpenStax::Exchange::Client.configure do |config|
        config.use_fake_client
      end
      client = OpenStax::Exchange::Client.send(:client)
      expect(client.is_real?).to be_falsy
    end
  end
end
