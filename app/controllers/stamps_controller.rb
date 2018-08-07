class StampsController < ApplicationController
  def show
    @stamp = Stamp.find(params[:id])
  end

  def new; end

  def index; end
end
