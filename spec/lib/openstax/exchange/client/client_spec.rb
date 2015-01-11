require 'spec_helper'

describe OpenStax::Exchange::Client do

  before(:each) do
    OpenStax::Exchange::Client::RealClient.configure do |config|
      config.platform_id     = '123'
      config.platform_secret = 'abc'
      config.server_base_url = 'http://localhost:3003'
      config.api_version     = 'v1'
    end
  end

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

  context "real client" do
    before(:each) do
      OpenStax::Exchange::Client.clear_client
      OpenStax::Exchange::Client.configure do |config|
        config.use_real_client
      end
    end

    context "API V1" do

      before(:each) do
        OpenStax::Exchange::Client::RealClient.configure do |config|
          config.api_version = 'v1'
        end
      end

      describe "#create_identifier" do
        context "success" do
          it "creates and returns a new identifier" do
            identifier = OpenStax::Exchange::Client.create_identifier
            expect(identifier).to match(/^[a-fA-F0-9]+$/)
          end
        end
      end

      describe "#create_multiple_choice" do
        context "success" do
          it "creates a multiple choice response associated with the given identifier" do
            identifier = OpenStax::Exchange::Client.create_identifier

            # must have the form of a "trusted resource"
            # (Exchange app/routines/find_or_create_resource_from_url.rb:35)
            resource_string = 'http://exercises.openstax.org/exercises/1234'
            trial           = '1'
            answer_string   = 'answer_string'

            response = OpenStax::Exchange::Client.create_multiple_choice(
              identifier, resource_string, trial, answer_string);

            expect(response['identifier']).to eq(identifier)
            expect(response['resource']).to eq(resource_string)
            expect(response['trial']).to eq(trial)
            expect(response['answer']).to eq(answer_string)
          end
        end
      end

    end

  end

  context "fake client" do
    # before(:each) do
    #   OpenStax::Exchange::Client.clear_client
    #   OpenStax::Exchange::Client.configure do |config|
    #     config.use_fake_client
    #   end
    # end

    context "API V1" do
      describe "#create_identifier" do
        context "success" do
          it "creates and returns a new identifier"
        end
      end
    end
  end

end
