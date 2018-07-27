class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  layout 'semantic'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index; end

  private

  def not_authorized
    flash[:alert] = 'You are not authorized to do this.'
    redirect_to(request.referrer || root_path)
  end
end
