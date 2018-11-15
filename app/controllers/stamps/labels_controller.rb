class StampsController < ApplicationController
  def new
    @stamp = Stamp.new
    @stamp.stampable = load_stampable
    @stamp.comments.build
    load_labels
    authorize @stamp
  end

  def create
    @stamp = Stamp.new(stamp_params)
    @stamp.stampable = load_stampable
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

    authorize @stamp
  end

  def index; end

  private

  def stamp_type
    @stamp_type ||= params[:type] if params[:type].in? Stamp::TYPES
  end

  def stamp_params
    params.require(:stamp)
          .permit(
            :label_id,
            :percentage
          )
  end

  def load_stampable
    if stamp_type == 'Stamp::Label'
      Domain.find_by(name: params[:domain_name] || params['stamp']['domain'])
    elsif stamp_type == 'Stamp::Flag'
      App.first
    end
  end

  def load_labels
    @labels = Label.order(Arel.sql('LOWER(name) ASC'))
  end
end
