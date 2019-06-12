class LabelPolicy < ApplicationPolicy
  attr_reader :user, :label

  def initialize(user, label)
    @user = user
    @label = label
  end

  def permitted_attributes
    if moderator?
      [:description]
    end
  end

  def index?
    true
  end

  def create?
    admin?
  end

  def show?
    true
  end

  def update?
    admin? || permitted_attributes
  end

  def edit?
    admin? || permitted_attributes
  end
end
