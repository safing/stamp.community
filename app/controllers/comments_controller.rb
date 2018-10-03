class CommentsController < ApplicationController
  before_action :load_commentable

  def create
    @comment = @commentable.comments.new(comment_params)
    authorize(@comment)
    @comment.user = current_user

    if @comment.save
      redirect_to(@commentable, flash: { success: 'Comment created' })
    else
      instance_variable_set "@#{@resource.singularize}".to_sym, @commentable
      @comments = @commentable.comments.where.not(id: nil)
      render "#{@resource}/show"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def load_commentable
    @resource, id = request.path.split('/')[1, 2]
    @votable = @commentable = @resource.singularize.classify.constantize.find(id)
  end
end
