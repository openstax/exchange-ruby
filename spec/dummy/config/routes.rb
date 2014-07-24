Rails.application.routes.draw do
  root :to => 'application#index'

  post 'oauth/token', :to => 'oauth#token'

  namespace :api do
    post 'dummy', :to => 'dummy#dummy'

    resources 'events', only: [:index]
    resources 'identifiers', only: [:create]

    scope '/events' do
			scope '/platforms' do
				event_routes :multiple_choices, to: 'input_events#create_multiple_choice'
				event_routes :free_responses, to: 'input_events#create_free_response'
				event_routes :messages
				event_routes :gradings
				event_routes :tasks
			end
		end
  end

  
end
