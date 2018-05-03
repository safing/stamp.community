class StampsController < ApplicationController
  def show
    @stamp = Stamp.find(params[:id])
  end
end
