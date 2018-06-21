class LicencePolicy < ApplicationPolicy
  attr_reader :user, :stamp

  def initialize(user, stamp)
    @user = user
    @stamp = stamp
  end

  def new?
    user.present? && user.admin?
  end

  def create?
    user.present? && user.admin?
  end

  def show?
    true
  end

  def edit?
    user.present? && user.admin?
  end

  def update?
    user.present? && user.admin?
  end
end
