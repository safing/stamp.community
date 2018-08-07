class StampsController < ApplicationController
  def new
    @stamp = Stamp.new
    authorize @stamp
  end

  def create
    @stamp = Stamp.new(stamp_params)
    authorize @stamp

    if @stamp.save
      redirect_to(stamps_url(@stamp.id), status: 201)
    else
      render 'new'
    end
  end

  def show
    @stamp = Stamp.find(params[:id])
    authorize @stamp
  end

  private

  def stamp_params
    params.require(:stamp)
          .permit(:label_id, :percentage, :stampable_id, :stampable_type)
          .merge(creator: current_user)
  end
end
