require 'spec_helper'

RSpec.shared_examples "exchange client api v1" do

  before(:each) do
    OpenStax::Exchange.reset!
    OpenStax::Exchange.configure do |config|
      config.client_platform_id     = DEFAULT_CLIENT_PLATFORM_ID
      config.client_platform_secret = DEFAULT_CLIENT_PLATFORM_SECRET
      config.client_server_url      = client_server_url
      config.client_api_version     = API_VERSION_V1
    end
  end

  describe "#initialize" do
    context "success" do
      it "initializes the authentication token" do
        client = OpenStax::Exchange.send(:client)
        expect(client.token).to_not be_nil
      end
    end
    context "invalid server" do
      it "raises an exception" do
        OpenStax::Exchange.configure do |config|
          config.client_server_url = client_server_url(host: 'this.is.a.fake.address')
        end
        expect {
          OpenStax::Exchange.send(:client)
        }.to raise_error(OpenStax::Exchange::ClientError)
      end
    end
    context "invalid port" do
      it "raises an exception" do
        OpenStax::Exchange.configure do |config|
          config.client_server_url = client_server_url(port: 9999)
        end
        expect {
          OpenStax::Exchange.send(:client)
        }.to raise_error(OpenStax::Exchange::ClientError)
      end
    end
    context "invalid platform id" do
      it "raises an exception" do
        OpenStax::Exchange.configure do |config|
          config.client_platform_id = '999'
        end
        expect {
          OpenStax::Exchange.send(:client)
        }.to raise_error(OpenStax::Exchange::ClientError)
      end
    end
    context "invalid platform secret" do
      it "raises an exception" do
        OpenStax::Exchange.configure do |config|
          config.client_platform_secret = 'not_the_secret'
        end
        expect {
          OpenStax::Exchange.send(:client)
        }.to raise_error(OpenStax::Exchange::ClientError)
      end
    end
  end

  describe "#create_identifier" do
    context "success" do
      it "creates and returns a new identifier" do
        response = OpenStax::Exchange.create_identifier
        read_identifier = response['read']
        write_identifier = response['write']
        expect(read_identifier).to match(/^[a-fA-F0-9]+$/)
        expect(write_identifier).to match(/^[a-fA-F0-9]+$/)
      end

      it "creates distinct identifiers per invokation" do
        response1 = OpenStax::Exchange.create_identifier
        response2 = OpenStax::Exchange.create_identifier
        identifier1 = response1['read']
        identifier2 = response1['write']
        identifier3 = response2['read']
        identifier4 = response2['write']
        expect(identifier1).to_not eq(identifier2)
        expect(identifier1).to_not eq(identifier3)
        expect(identifier1).to_not eq(identifier4)
        expect(identifier2).to_not eq(identifier3)
        expect(identifier2).to_not eq(identifier4)
        expect(identifier3).to_not eq(identifier4)
      end
    end
  end

  describe "#record_multiple_choice_answer" do
    context "success" do
      it "creates a multiple choice answer associated with the given identifier" do
        identifier = OpenStax::Exchange.create_identifier['write']

        # must have the form of a "trusted resource"
        # (Exchange app/routines/find_or_create_resource_from_url.rb:35)
        resource_string = 'https://exercises-dev1.openstax.org/api/exercises/123@1'
        trial           = '1'
        answer_string   = 'answer_string'

        response = OpenStax::Exchange.record_multiple_choice_answer(
          identifier, resource_string, trial, answer_string)

        expect(response['identifier']).to eq(identifier)
        expect(response['resource']).to eq(resource_string)
        expect(response['trial']).to eq(trial)
        expect(response['answer']).to eq(answer_string)
      end
      it "allows answers with distinct identifiers to be saved" do
        identifier1 = OpenStax::Exchange.create_identifier['write']
        identifier2 = OpenStax::Exchange.create_identifier['write']

        # must have the form of a "trusted resource"
        # (Exchange app/routines/find_or_create_resource_from_url.rb:35)
        resource_string = 'https://exercises-dev1.openstax.org/api/exercises/123@1'
        trial           = '1'
        answer_string   = 'answer_string'

        response = nil

        expect {
          response = OpenStax::Exchange.record_multiple_choice_answer(
            identifier1, resource_string, trial, answer_string)
        }.to_not raise_error
        expect(response['identifier']).to eq(identifier1)

        expect {
          response = OpenStax::Exchange.record_multiple_choice_answer(
            identifier2, resource_string, trial, answer_string)
        }.to_not raise_error
        expect(response['identifier']).to eq(identifier2)
      end
      it "allows answers with distinct resources to be saved" do
        identifier = OpenStax::Exchange.create_identifier['write']

        # must have the form of a "trusted resource"
        # (Exchange app/routines/find_or_create_resource_from_url.rb:35)
        resource_string1 = 'https://exercises-dev1.openstax.org/api/exercises/12@1'
        resource_string2 = 'https://exercises-dev1.openstax.org/api/exercises/123@1'
        trial            = '1'
        answer_string    = 'answer_string'

        response = nil

        expect {
          response = OpenStax::Exchange.record_multiple_choice_answer(
            identifier, resource_string1, trial, answer_string)
        }.to_not raise_error
        expect(response['resource']).to eq(resource_string1)

        expect {
          response = OpenStax::Exchange.record_multiple_choice_answer(
            identifier, resource_string2, trial, answer_string)
        }.to_not raise_error
        expect(response['resource']).to eq(resource_string2)
      end
      it "allows answers with distinct trials to be saved" do
        identifier = OpenStax::Exchange.create_identifier['write']

        # must have the form of a "trusted resource"
        # (Exchange app/routines/find_or_create_resource_from_url.rb:35)
        resource_string = 'https://exercises-dev1.openstax.org/api/exercises/123@1'
        trial1          = '1'
        trial2          = '2'
        answer_string   = 'answer_string'

        response = nil

        expect {
          response = OpenStax::Exchange.record_multiple_choice_answer(
            identifier, resource_string, trial1, answer_string)
        }.to_not raise_error
        expect(response['trial']).to eq(trial1)

        expect {
          response = OpenStax::Exchange.record_multiple_choice_answer(
            identifier, resource_string, trial2, answer_string)
        }.to_not raise_error
        expect(response['trial']).to eq(trial2)
      end
    end
    context "duplicate (identifer,resource,trial) triplet" do
      it "raises an exception" do
        identifier = OpenStax::Exchange.create_identifier['write']

        # must have the form of a "trusted resource"
        # (Exchange app/routines/find_or_create_resource_from_url.rb:35)
        resource_string = 'https://exercises-dev1.openstax.org/api/exercises/123@1'
        trial           = '1'
        answer_string   = 'answer_string'

        expect {
          response = OpenStax::Exchange.record_multiple_choice_answer(
            identifier, resource_string, trial, answer_string)
        }.to_not raise_error

        expect {
          response = OpenStax::Exchange.record_multiple_choice_answer(
            identifier, resource_string, trial, answer_string)
        }.to raise_error(OpenStax::Exchange::ClientError)
      end
    end
    context "invalid resource string" do
      it "raises an exception" do
        identifier = OpenStax::Exchange.create_identifier['write']

        # must have the form of a "trusted resource"
        # (Exchange app/routines/find_or_create_resource_from_url.rb:35)
        resource_string = 'https://example.com/api/exercises/123@1'
        trial           = '1'
        answer_string   = 'answer_string'

        expect {
          response = OpenStax::Exchange.record_multiple_choice_answer(
            identifier, resource_string, trial, answer_string)
        }.to raise_error(OpenStax::Exchange::ClientError)
      end
    end
  end
end
