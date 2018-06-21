class LicencePolicy < ApplicationPolicy
  attr_reader :user, :stamp

  def initialize(user, stamp)
    @user = user
    @stamp = stamp
  end

  def new?
    user.present?
  end

  def create?
    user.present?
  end

  def show?
    true
  end

  def edit?
    user.present?
  end

  def update?
    user.present?
  end
end
