class LicencePolicy < ApplicationPolicy
  attr_reader :user, :licence

  def initialize(user, licence)
    @user = user
    @licence = licence
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
