class UserPolicy < ApplicationPolicy
  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def new?
    current_user.present?
  end

  def create?
    current_user.present?
  end

  def show?
    true
  end

  def edit?
    current_user.present?
  end

  def update?
    current_user.present?
  end
end
