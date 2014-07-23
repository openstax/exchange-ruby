Rails.application.routes.draw do
  root :to => 'application#index'

  post 'oauth/token', :to => 'oauth#token'

  namespace :api do
    post 'dummy', :to => 'dummy#dummy'

    resources 'events', only: [:index]
    resources 'identifiers', only: [:create]
  end


end
