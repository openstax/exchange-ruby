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

  describe "#create_identifiers" do
    context "success" do
      it "creates and returns a new identifier" do
        response = OpenStax::Exchange.create_identifiers
        read_identifier = response.read
        write_identifier = response.write
        expect(read_identifier).to match(/^[a-fA-F0-9]+$/)
        expect(write_identifier).to match(/^[a-fA-F0-9]+$/)
      end

      it "creates distinct identifiers per invokation" do
        response1 = OpenStax::Exchange.create_identifiers
        response2 = OpenStax::Exchange.create_identifiers
        identifier1 = response1.read
        identifier2 = response1.write
        identifier3 = response2.read
        identifier4 = response2.write
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
        identifier = OpenStax::Exchange.create_identifiers.write

        # must have the form of a "trusted resource"
        # (Exchange app/routines/find_or_create_resource_from_url.rb:35)
        resource_string = 'https://exercises-dev1.openstax.org/api/exercises/123@1'
        trial           = '1'
        answer_string   = 'answer_string'

        response = OpenStax::Exchange.record_multiple_choice_answer(
          identifier, resource_string, trial, answer_string
        )

        expect(response['identifier']).to eq(identifier)
        expect(response['resource']).to eq(resource_string)
        expect(response['trial']).to eq(trial)
        expect(response['answer']).to eq(answer_string)
      end
      it "allows answers with distinct identifiers to be saved" do
        identifier1 = OpenStax::Exchange.create_identifiers.write
        identifier2 = OpenStax::Exchange.create_identifiers.write

        # must have the form of a "trusted resource"
        # (Exchange app/routines/find_or_create_resource_from_url.rb:35)
        resource_string = 'https://exercises-dev1.openstax.org/api/exercises/123@1'
        trial           = '1'
        answer_string   = 'answer_string'

        response = nil

        expect {
          response = OpenStax::Exchange.record_multiple_choice_answer(
            identifier1, resource_string, trial, answer_string
          )
        }.to_not raise_error
        expect(response['identifier']).to eq(identifier1)

        expect {
          response = OpenStax::Exchange.record_multiple_choice_answer(
            identifier2, resource_string, trial, answer_string
          )
        }.to_not raise_error
        expect(response['identifier']).to eq(identifier2)
      end
      it "allows answers with distinct resources to be saved" do
        identifier = OpenStax::Exchange.create_identifiers.write

        # must have the form of a "trusted resource"
        # (Exchange app/routines/find_or_create_resource_from_url.rb:35)
        resource_string1 = 'https://exercises-dev1.openstax.org/api/exercises/12@1'
        resource_string2 = 'https://exercises-dev1.openstax.org/api/exercises/123@1'
        trial            = '1'
        answer_string    = 'answer_string'

        response = nil

        expect {
          response = OpenStax::Exchange.record_multiple_choice_answer(
            identifier, resource_string1, trial, answer_string
          )
        }.to_not raise_error
        expect(response['resource']).to eq(resource_string1)

        expect {
          response = OpenStax::Exchange.record_multiple_choice_answer(
            identifier, resource_string2, trial, answer_string
          )
        }.to_not raise_error
        expect(response['resource']).to eq(resource_string2)
      end
      it "allows answers with distinct trials to be saved" do
        identifier = OpenStax::Exchange.create_identifiers.write

        # must have the form of a "trusted resource"
        # (Exchange app/routines/find_or_create_resource_from_url.rb:35)
        resource_string = 'https://exercises-dev1.openstax.org/api/exercises/123@1'
        trial1          = '1'
        trial2          = '2'
        answer_string   = 'answer_string'

        response = nil

        expect {
          response = OpenStax::Exchange.record_multiple_choice_answer(
            identifier, resource_string, trial1, answer_string
          )
        }.to_not raise_error
        expect(response['trial']).to eq(trial1)

        expect {
          response = OpenStax::Exchange.record_multiple_choice_answer(
            identifier, resource_string, trial2, answer_string
          )
        }.to_not raise_error
        expect(response['trial']).to eq(trial2)
      end
    end
    context "duplicate (identifer,resource,trial) triplet" do
      it "records the new answer" do
        identifier = OpenStax::Exchange.create_identifiers.write

        # must have the form of a "trusted resource"
        # (Exchange app/routines/find_or_create_resource_from_url.rb:35)
        resource_string = 'https://exercises-dev1.openstax.org/api/exercises/123@1'
        trial           = '1'
        answer_string   = 'answer_string'
        answer_string_2 = 'another_string'

        response = nil
        expect {
          response = OpenStax::Exchange.record_multiple_choice_answer(
            identifier, resource_string, trial, answer_string
          )
        }.to_not raise_error

        expect(response['answer']).to eq answer_string

        expect {
          response = OpenStax::Exchange.record_multiple_choice_answer(
            identifier, resource_string, trial, answer_string_2
          )
        }.to_not raise_error

        expect(response['answer']).to eq answer_string_2
      end
    end
    context "invalid resource string" do
      it "raises an exception" do
        identifier = OpenStax::Exchange.create_identifiers.write

        # must have the form of a "trusted resource"
        # (Exchange app/routines/find_or_create_resource_from_url.rb:35)
        resource_string = 'https://example.com/api/exercises/123@1'
        trial           = '1'
        answer_string   = 'answer_string'

        expect {
          response = OpenStax::Exchange.record_multiple_choice_answer(
            identifier, resource_string, trial, answer_string
          )
        }.to raise_error(OpenStax::Exchange::ClientError)
      end
    end
  end

  describe "#record_grade" do
    context "success" do
      it "records the exercise grade for the given identifier" do
        identifier = OpenStax::Exchange.create_identifiers.write

        # must have the form of a "trusted resource"
        # (Exchange app/routines/find_or_create_resource_from_url.rb:35)
        resource_string = 'https://exercises-dev1.openstax.org/api/exercises/123@1'
        trial           = '1'
        grade           = 1.0
        grader_string   = 'openstax'

        response = OpenStax::Exchange.record_grade(
          identifier, resource_string, trial, grade, grader_string
        )

        expect(response['identifier']).to eq(identifier)
        expect(response['resource']).to eq(resource_string)
        expect(response['trial']).to eq(trial)
        expect(response['grade']).to eq(grade)
        expect(response['grader']).to eq(grader_string)
      end
      it "allows grades for distinct identifiers to be saved" do
        identifier1 = OpenStax::Exchange.create_identifiers.write
        identifier2 = OpenStax::Exchange.create_identifiers.write

        # must have the form of a "trusted resource"
        # (Exchange app/routines/find_or_create_resource_from_url.rb:35)
        resource_string = 'https://exercises-dev1.openstax.org/api/exercises/123@1'
        trial           = '1'
        grade           = 1.0
        grader_string   = 'openstax'

        response = nil

        expect {
          response = OpenStax::Exchange.record_grade(
            identifier1, resource_string, trial, grade, grader_string
          )
        }.to_not raise_error
        expect(response['identifier']).to eq(identifier1)

        expect {
          response = OpenStax::Exchange.record_grade(
            identifier2, resource_string, trial, grade, grader_string
          )
        }.to_not raise_error
        expect(response['identifier']).to eq(identifier2)
      end
      it "allows grades for distinct resources to be saved" do
        identifier = OpenStax::Exchange.create_identifiers.write

        # must have the form of a "trusted resource"
        # (Exchange app/routines/find_or_create_resource_from_url.rb:35)
        resource_string1 = 'https://exercises-dev1.openstax.org/api/exercises/12@1'
        resource_string2 = 'https://exercises-dev1.openstax.org/api/exercises/123@1'
        trial            = '1'
        grade            = 1.0
        grader_string    = 'openstax'

        response = nil

        expect {
          response = OpenStax::Exchange.record_grade(
            identifier, resource_string1, trial, grade, grader_string
          )
        }.to_not raise_error
        expect(response['resource']).to eq(resource_string1)

        expect {
          response = OpenStax::Exchange.record_grade(
            identifier, resource_string2, trial, grade, grader_string
          )
        }.to_not raise_error
        expect(response['resource']).to eq(resource_string2)
      end
      it "allows grades for distinct trials to be saved" do
        identifier = OpenStax::Exchange.create_identifiers.write

        # must have the form of a "trusted resource"
        # (Exchange app/routines/find_or_create_resource_from_url.rb:35)
        resource_string = 'https://exercises-dev1.openstax.org/api/exercises/123@1'
        trial1          = '1'
        trial2          = '2'
        grade           = 1.0
        grader_string   = 'openstax'

        response = nil

        expect {
          response = OpenStax::Exchange.record_grade(
            identifier, resource_string, trial1, grade, grader_string
          )
        }.to_not raise_error
        expect(response['trial']).to eq(trial1)

        expect {
          response = OpenStax::Exchange.record_grade(
            identifier, resource_string, trial2, grade, grader_string
          )
        }.to_not raise_error
        expect(response['trial']).to eq(trial2)
      end
    end
    context "duplicate (identifer,resource,trial) triplet" do
      it "records the new grade" do
        identifier = OpenStax::Exchange.create_identifiers.write

        # must have the form of a "trusted resource"
        # (Exchange app/routines/find_or_create_resource_from_url.rb:35)
        resource_string = 'https://exercises-dev1.openstax.org/api/exercises/123@1'
        trial           = '1'
        grade           = 0.0
        grade_2         = 1.0
        grader_string   = 'openstax'
        grader_string_2 = 'tutor'

        response = nil
        expect {
          response = OpenStax::Exchange.record_grade(
            identifier, resource_string, trial, grade, grader_string
          )
        }.to_not raise_error

        expect(response['grade']).to eq grade
        expect(response['grader']).to eq grader_string

        expect {
          response = OpenStax::Exchange.record_grade(
            identifier, resource_string, trial, grade_2, grader_string_2
          )
        }.to_not raise_error

        expect(response['grade']).to eq grade_2
        expect(response['grader']).to eq grader_string_2
      end
    end
    context "invalid resource string" do
      it "raises an exception" do
        identifier = OpenStax::Exchange.create_identifiers.write

        # must have the form of a "trusted resource"
        # (Exchange app/routines/find_or_create_resource_from_url.rb:35)
        resource_string = 'https://example.com/api/exercises/123@1'
        trial           = '1'
        grade           = 1.0
        grader_string   = 'openstax'

        expect {
          response = OpenStax::Exchange.record_grade(
            identifier, resource_string, trial, grade, grader_string
          )
        }.to raise_error(OpenStax::Exchange::ClientError)
      end
    end
  end
end
