class LabelsController < ApplicationController
  def show
    @label = Label.find(params[:id])
  end

  def index
    @parents = Label.where(parent_id: nil)
  end
end
