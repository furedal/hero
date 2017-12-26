class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  rescue_from Exceptions::SIError, with: :handle_api_error

  def handle_api_error(e)
    render :json => e.error_object, status: e.http_error_code
  end
end
