class VotePolicy < ApplicationPolicy
  attr_reader :user, :vote

  def initialize(user, vote)
    @user = user
    @vote = vote
  end

  def new?
    user.present?
  end

  def create?
    user.present?
  end

  def show?
    user.present?
  end

  def edit?
    false
  end

  def update?
    false
  end
end
