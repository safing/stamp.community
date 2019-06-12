class LabelsController < ApplicationController
  def show
    @label = Label.find(params[:id])
  end

  def index
    @parents = Label.where(parent_id: nil)
  end

  def new
    @label = Label.new
    authorize(@label)
  end

  def create
    @label = Label.new(label_params)
    authorize(@label)
    if @label.save
      redirect_to(label_path(@label), flash: { success: 'Label created successfully' })
    else
      render 'new'
    end
  end

  def edit
    @label = Label.find(params[:id])
    authorize(@label)
    render action: 'new'
  end

  def update
    @label = Label.find(params[:id])
    authorize(@label)

    if @label.update(permitted_attributes(@label))
      redirect_to label_path(@label)
    else
      render action: 'new'
    end
  end

  def label_params
    params.require(:label).permit(:name, :description, :licence_id, :parent_id)
  end
end
