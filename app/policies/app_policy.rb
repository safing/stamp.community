class AppPolicy < ApplicationPolicy
  attr_reader :user, :app

  def initialize(user, app)
    @user = user
    @app = app
  end

  def create?
    moderator?
  end

  def show?
    true
  end

  def update?
    moderator?
  end
end
