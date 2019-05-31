class UserPolicy < ApplicationPolicy
  attr_reader :user, :targeted_user

  def initialize(user, targeted_user)
    @user = user
    @targeted_user = targeted_user
  end

  def create?
    false
  end

  def show?
    true
  end

  def update?
    admin? || user == targeted_user
  end
end
