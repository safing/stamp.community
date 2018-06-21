class DomainPolicy < ApplicationPolicy
  attr_reader :user, :domain

  def initialize(user, domain)
    @user = user
    @domain = domain
  end

  def new?
    user?
  end

  def create?
    user?
  end

  def show?
    true
  end

  def edit?
    admin?
  end

  def update?
    admin?
  end
end
