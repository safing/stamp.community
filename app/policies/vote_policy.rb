class VotePolicy < ApplicationPolicy
  attr_reader :user, :vote

  def initialize(user, vote)
    @user = user
    @vote = vote
  end

  def create?
    user?
  end

  def show?
    moderator?
  end

  def update?
    false
  end
end
