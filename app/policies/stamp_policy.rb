class StampPolicy < ApplicationPolicy
  attr_reader :user, :stamp

  def initialize(user, stamp)
    @user = user
    @stamp = stamp
  end

  def create?
    user?
  end

  def show?
    true
  end

  def update?
    false
  end
end
