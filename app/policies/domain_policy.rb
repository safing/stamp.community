class DomainPolicy < ApplicationPolicy
  attr_reader :user, :domain

  def initialize(user, domain)
    @user = user
    @domain = domain
  end

  def create?
    user?
  end

  def show?
    true
  end

  def update?
    admin?
  end
end
