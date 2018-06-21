class DomainPolicy < ApplicationPolicy
  attr_reader :user, :domain

  def initialize(user, domain)
    @user = user
    @domain = domain
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
