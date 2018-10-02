class CommentPolicy < ApplicationPolicy
  attr_reader :user, :comment

  def initialize(user, comment)
    @user = user
    @comment = comment
  end

  def create?
    user? && comment.commentable.in_progress? || moderator?
  end

  def show?
    false
  end

  def update?
    false
  end
end
