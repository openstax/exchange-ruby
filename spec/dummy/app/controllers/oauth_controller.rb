class OauthController < ApplicationController
  respond_to :json

  def token
    render :json => { :access_token => 'dummy',
                      :token_type => 'dummy' }
  end
end
