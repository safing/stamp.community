class AppPolicy < ApplicationPolicy
  attr_reader :user, :app

  def initialize(user, app)
    @user = user
    @app = app
  end

  def index?
    access_flag_stamps?
  end
  
  def show?
    access_flag_stamps?
  end

  def create?
    access_flag_stamps?
  end

  def update?
    access_flag_stamps?
  end
end
