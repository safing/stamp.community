class StampsController < ApplicationController
  def new
    @stamp = Stamp.new
    @stamp.comments.build
    load_labels
    authorize @stamp
  end

  def create
    @stamp = Stamp.new(stamp_params)
    authorize @stamp

    if @stamp.save
      redirect_to(stamp_url(@stamp.id), flash: { success: 'Stamp created successfully' })
    else
      load_labels
      render 'new'
    end
  end

  def show
    @stamp = Stamp.find(params[:id])
    authorize @stamp
  end

  def index; end

  private

  def stamp_params
    params.require(:stamp)
          .merge(creator: current_user)
          .permit(
            :label_id,
            :percentage,
            :stampable_id,
            :stampable_type,
            comments_attributes: [:content]
          )
  end

  def load_labels
    @labels = Label.order('LOWER(name) ASC')
  end
end
