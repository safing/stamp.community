class LabelPolicy < ApplicationPolicy
  attr_reader :user, :label

  def initialize(user, label)
    @user = user
    @label = label
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
