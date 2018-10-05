class VotesController < ApplicationController
  before_action :load_votable

  def create
    @vote = @votable.votes.new(vote_params)
    authorize(@vote)
    @vote.user = current_user
    @vote.power = current_user.voting_power

    if @vote.save
      redirect_to(@votable, flash: { success: 'Successfully voted ' })
    else
      redirect_to(@votable, flash: { error: 'Cannot vote twice' })
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:accept)
  end

  def load_votable
    @resource, id = request.path.split('/')[1, 2]
    @votable = @commentable = @resource.singularize.classify.constantize.find(id)
  end
end
