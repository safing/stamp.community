class LabelPolicy < ApplicationPolicy
  attr_reader :user, :label

  def initialize(user, label)
    @user = user
    @label = label
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
