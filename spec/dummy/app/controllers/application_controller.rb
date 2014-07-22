class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    render :json => {head: 'no_content'}
  end
end
