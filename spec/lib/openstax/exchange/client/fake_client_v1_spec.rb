require 'spec_helper'

describe OpenStax::Exchange::Client do

  context "fake client api v1" do

    before(:each) do
      OpenStax::Exchange::Client.clear_client
      OpenStax::Exchange::Client.use_fake_client
      OpenStax::Exchange::Client.configure do |config|
        config.platform_id     = DEFAULT_CLIENT_PLATFORM_ID
        config.platform_secret = DEFAULT_CLIENT_PLATFORM_SECRET
        config.server_base_url = DEFAULT_CLIENT_SERVER_BASE_URL
        config.server_port     = DEFAULT_CLIENT_SERVER_PORT
        config.api_version     = API_VERSION_V1
      end

      OpenStax::Exchange::Client::FakeClient.configure do |config|
        config.registered_platforms = {DEFAULT_CLIENT_PLATFORM_ID => DEFAULT_CLIENT_PLATFORM_SECRET}
      end
    end

    describe "#initialize" do
      context "success" do
        it "initializes the authentication token" do
          client = OpenStax::Exchange::Client.send(:client)
          expect(client.token).to_not be_nil
        end
      end
    end

    describe "#create_identifier" do
      context "success" do
        it "creates and returns a new identifier" do
          identifier = OpenStax::Exchange::Client.create_identifier
          expect(identifier).to match(/^[a-fA-F0-9]+$/)
        end
        it "creates a distinct identifer per invokation" do
          identifier1 = OpenStax::Exchange::Client.create_identifier
          identifier2 = OpenStax::Exchange::Client.create_identifier
          expect(identifier1).to_not eq(identifier2)
        end
      end
      context "invalid platform id" do
        it "raises an exception" do
          OpenStax::Exchange::Client.configure do |config|
            config.platform_id = '999'
          end
          expect {
            OpenStax::Exchange::Client.send(:client)
          }.to raise_error(OpenStax::Exchange::Client::ClientError)
        end
      end
      context "invalid platform secret" do
        it "raises an exception" do
          OpenStax::Exchange::Client.configure do |config|
            config.platform_secret = 'not_the_secret'
          end
          expect {
            OpenStax::Exchange::Client.send(:client)
          }.to raise_error(OpenStax::Exchange::Client::ClientError)
        end
      end
    end

  end

end
