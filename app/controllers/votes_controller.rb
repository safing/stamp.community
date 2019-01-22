class VotesController < ApplicationController
  before_action :load_votable

  def create
    @vote = @votable.votes.new(vote_params)
    authorize(@vote)
    @vote.user = current_user
    @vote.power = current_user.voting_power

    if @vote.save
      @vote.create_activity :create, owner: current_user, recipient: @votable
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
    @votable = @resource.singularize.classify.constantize.find(id)

    # route helpers rely on the correct STI class
    @votable = @votable.type.constantize.find(id) if @votable.respond_to? :type
    @commentable = @votable
  end
end
