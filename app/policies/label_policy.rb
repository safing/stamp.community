class LabelPolicy < ApplicationPolicy
  attr_reader :user, :label

  def initialize(user, label)
    @user = user
    @label = label
  end

  def permitted_attributes
    if admin?
      [:name, :description, :licence_id, :parent_id]
    elsif moderator?
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
    moderator?
  end

  def edit?
    moderator?
  end
end
