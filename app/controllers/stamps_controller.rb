class StampsController < ApplicationController
  def show
    @stamp = Stamp.find(params[:id])
    authorize @stamp
  end
end
