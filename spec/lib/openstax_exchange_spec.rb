require 'rails_helper'

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
      opt = {:resource => "Necesito practicar espanol.",
             :attempt => 5,
             :value => "C"}
      res = Exchange.create_multiple_choice(id, opt)
      expect(Api::InputEventsController.last_action).to eq :multiple_choices
      expect(Api::InputEventsController.last_params).to include :identifier => id
      expect(Api::InputEventsController.last_params).to include opt.to_json
    end

    it 'records a free response answer' do
      Api::InputEventsController.last_action = nil
      Api::InputEventsController.last_params = nil
      id = Exchange.create_identifier["identifier"]
      opt = {:resource => "OST",
             :attempt => 2,
             :value => "Wingardium Leviosa"}
      res = Exchange.create_free_response(id, opt)
      expect(Api::InputEventsController.last_action).to eq :free_responses
      expect(Api::InputEventsController.last_params).to include :identifier => id
      expect(Api::InputEventsController.last_params).to include opt.to_json
    end

    it 'creates a task event' do
      Api::TaskEventsController.last_action = nil
      Api::TaskEventsController.last_params = nil
      id = Exchange.create_identifier["identifier"]
      opt = {:attempt => 1,
             :resource => "YAY",
             :status => "completed",
             :due_date => "Tuesday"}
      res = Exchange.create_task(id, opt)
      expect(Api::TaskEventsController.last_action).to eq :tasks
      expect(Api::TaskEventsController.last_params).to include :identifier => id
      expect(Api::TaskEventsController.last_params).to include opt.to_json
    end

    it 'creates a grading event' do
      Api::GradingEventsController.last_action = nil
      Api::GradingEventsController.last_params = nil
      id = Exchange.create_identifier["identifier"]
      opt = {:resource => "abcd",
             :attempt => 12,
             :grade => "A",
             :feedback => "Perfect!"}
      res = Exchange.create_grading(id, opt)
      expect(Api::GradingEventsController.last_action).to eq :gradings
      expect(Api::GradingEventsController.last_params).to include :identifier => id
      expect(Api::GradingEventsController.last_params).to include opt.to_json
    end

    it 'creates a message event' do
      Api::MessageEventsController.last_action = nil
      Api::MessageEventsController.last_params = nil
      id = Exchange.create_identifier["identifier"]
      opt = {:to => "Harry",
             :subject => "Hogwarts",
             :body => "An owl should be arriving soon with your supplies list."}
      res = Exchange.create_message(id, opt)
      expect(Api::MessageEventsController.last_action).to eq :messages
      expect(Api::MessageEventsController.last_params).to include :identifier => id
      expect(Api::MessageEventsController.last_params).to include opt.to_json
    end
  end
end
