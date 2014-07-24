require 'spec_helper'

module OpenStax
  describe Exchange do

    it 'makes api calls' do
      expect(::Api::DummyController.last_action).to be_nil
      expect(Api::DummyController.last_params).to be_nil
      Exchange.api_call(:post, 'dummy', :params => {:test => true})
      expect(Api::DummyController.last_action).to eq :dummy
      expect(Api::DummyController.last_params).to include 'test' => 'true'
    end

    it 'makes api calls to events (index)' do
      Api::EventsController.last_action = nil
      Api::EventsController.last_params = nil
      Exchange.search_events('sth')
      expect(Api::EventsController.last_action).to eq :index
      expect(Api::EventsController.last_params).to include :q => 'sth'
    end

    it 'creates an identifier' do
      Api::IdentifiersController.last_action = nil
      Api::IdentifiersController.last_params = nil
      res = Exchange.create_identifier()
      expect(Api::IdentifiersController.last_action).to eq :create
      expect(res["identifier"]).to be_instance_of String
    end

    it 'records a multiple choice answer' do
      Api::InputEventsController.last_action = nil
      Api::InputEventsController.last_params = nil
      id = Exchange.create_identifier["identifier"]
      res = Exchange.create_multiple_choice(id)
      expect(Api::InputEventsController.last_action).to eq :multiple_choices
      expect(Api::InputEventsController.last_params).to include :identifier => id
    end

    it 'records a free response answer' do
      Api::InputEventsController.last_action = nil
      Api::InputEventsController.last_params = nil
      id = Exchange.create_identifier["identifier"]
      res = Exchange.create_free_response(id)
      expect(Api::InputEventsController.last_action).to eq :free_responses
      expect(Api::InputEventsController.last_params).to include :identifier => id
    end


  end
end