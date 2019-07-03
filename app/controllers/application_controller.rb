class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_action :verify_authorized, except: :index

  def index; end

  private

  def not_authorized
    if user_signed_in?
      # state: unauthorized, response: 403 forbidden
      render file: 'public/403.html', status: 403
    else
      # state: unauthenticated, response: 401 unauthenticated
      render file: 'public/401.html', status: 401
    end
  end
end
