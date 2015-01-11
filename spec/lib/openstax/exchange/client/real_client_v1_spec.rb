require 'spec_helper'

describe OpenStax::Exchange::Client do

  context "real client api v1" do

    before(:each) do
      OpenStax::Exchange::Client.reset!
      OpenStax::Exchange::Client.use_real_client
      OpenStax::Exchange::Client.configure do |config|
        config.platform_id     = DEFAULT_CLIENT_PLATFORM_ID
        config.platform_secret = DEFAULT_CLIENT_PLATFORM_SECRET
        config.server_base_url = DEFAULT_CLIENT_SERVER_BASE_URL
        config.server_port     = DEFAULT_CLIENT_SERVER_PORT
        config.api_version     = API_VERSION_V1
      end
    end

    describe "#initialize" do
      context "success" do
        it "initializes the authentication token" do
          client = OpenStax::Exchange::Client.send(:client)
          expect(client.token).to_not be_nil
        end
      end
      context "invalid server" do
        it "raises an exception" do
          OpenStax::Exchange::Client.configure do |config|
            config.server_base_url = 'http://this.is.a.fake.address'
          end
          expect {
            OpenStax::Exchange::Client.send(:client)
          }.to raise_error(OpenStax::Exchange::Client::ClientError)
        end
      end
      context "invalid port" do
        it "raises an exception" do
          OpenStax::Exchange::Client.configure do |config|
            config.server_port = 9999
          end
          expect {
            OpenStax::Exchange::Client.send(:client)
          }.to raise_error(OpenStax::Exchange::Client::ClientError)
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
            identifier, resource_string, trial, answer_string)

          expect(response['identifier']).to eq(identifier)
          expect(response['resource']).to eq(resource_string)
          expect(response['trial']).to eq(trial)
          expect(response['answer']).to eq(answer_string)
        end
        it "allows multiple trials per resource" do
          identifier = OpenStax::Exchange::Client.create_identifier

          # must have the form of a "trusted resource"
          # (Exchange app/routines/find_or_create_resource_from_url.rb:35)
          resource_string = 'http://exercises.openstax.org/exercises/1234'
          trial1          = '1'
          trial2          = '2'
          answer_string   = 'answer_string'

          response = nil

          expect {
            response = OpenStax::Exchange::Client.create_multiple_choice(
              identifier, resource_string, trial1, answer_string)
          }.to_not raise_error
          expect(response['trial']).to eq(trial1)

          expect {
            response = OpenStax::Exchange::Client.create_multiple_choice(
              identifier, resource_string, trial2, answer_string)
          }.to_not raise_error
          expect(response['trial']).to eq(trial2)
        end
      end
      context "duplicate response for a given trial" do
        it "raises an exception" do
          identifier = OpenStax::Exchange::Client.create_identifier

          # must have the form of a "trusted resource"
          # (Exchange app/routines/find_or_create_resource_from_url.rb:35)
          resource_string = 'http://exercises.openstax.org/exercises/1234'
          trial           = '1'
          answer_string   = 'answer_string'

          expect {
            response = OpenStax::Exchange::Client.create_multiple_choice(
              identifier, resource_string, trial, answer_string)
          }.to_not raise_error

          expect {
            response = OpenStax::Exchange::Client.create_multiple_choice(
              identifier, resource_string, trial, answer_string)
          }.to raise_error(OpenStax::Exchange::Client::ClientError)
        end
      end
      context "invalid resource string" do
        it "raises an exception" do
          identifier = OpenStax::Exchange::Client.create_identifier

          # must have the form of a "trusted resource"
          # (Exchange app/routines/find_or_create_resource_from_url.rb:35)
          resource_string = 'http://example.com/exercises/1234'
          trial           = '1'
          answer_string   = 'answer_string'

          expect {
            response = OpenStax::Exchange::Client.create_multiple_choice(
              identifier, resource_string, trial, answer_string)
          }.to raise_error(OpenStax::Exchange::Client::ClientError)
        end
      end
    end

  end
end