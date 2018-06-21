class LabelPolicy < ApplicationPolicy
  attr_reader :user, :label

  def initialize(user, label)
    @user = user
    @label = label
  end

  def new?
    admin?
  end

  def create?
    admin?
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
