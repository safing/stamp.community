class LicencePolicy < ApplicationPolicy
  attr_reader :user, :stamp

  def initialize(user, stamp)
    @user = user
    @stamp = stamp
  end

  def create?
    admin?
  end

  def show?
    true
  end

  def update?
    admin?
  end
end
