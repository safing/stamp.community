class LabelsController < ApplicationController
  def show
    @label = Label.find(params[:id])
  end
end
