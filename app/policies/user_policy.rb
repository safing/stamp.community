class UserPolicy < ApplicationPolicy
  attr_reader :user, :targeted_user

  def initialize(user, targeted_user)
    @user = user
    @targeted_user = targeted_user
  end

  def permitted_attributes
    if user == targeted_user && view_flag_stamps?
      [:description, :flag_stamps]
    else
      [:description]
    end
  end

  def create?
    false
  end

  def show?
    true
  end

  def update?
    # always allow edits on themselves
    # OR allow admins all edits except when target is admin too
    user == targeted_user || admin? && !targeted_user.admin?
  end

  def view_flag_stamps?
    admin?
  end
end
