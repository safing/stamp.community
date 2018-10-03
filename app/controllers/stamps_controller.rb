class StampsController < ApplicationController
  def new
    @stamp = Stamp.new
    @stamp.stampable = load_domain
    @stamp.comments.build
    load_labels
    authorize @stamp
  end

  def create
    @stamp = Stamp.new(stamp_params)
    @stamp.stampable = load_domain
    @stamp.creator = @stamp.comments.first.user = current_user
    authorize @stamp

    if @stamp.save
      redirect_to(stamp_path(@stamp.id), flash: { success: 'Stamp created successfully' })
    else
      load_labels
      render 'new'
    end
  end

  def show
    @commentable = @votable = @stamp = Stamp.find(params[:id])
    @comments = @commentable.comments
    @comment = Comment.new
    @vote = Vote.new

    authorize @stamp
  end

  def index; end

  private

  def stamp_params
    params.require(:stamp)
          .permit(
            :label_id,
            :percentage,
            comments_attributes: [:content]
          )
  end

  def load_domain
    Domain.find_by(name: params[:domain_name] || params['stamp']['domain'])
  end

  def load_labels
    @labels = Label.order('LOWER(name) ASC')
  end
end
