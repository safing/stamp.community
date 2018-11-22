class AppsController < ApplicationController
  def show
    @app = App.find(params[:id])
    authorize @app
  end

  def new
    @app = App.new
    authorize @app
  end

  def create
    @app = App.new(app_params)
    @app.user = current_user
    authorize(@app)

    if @app.save
      redirect_to(app_path(@app.id), flash: { success: 'App created successfully' })
    else
      render 'new'
    end
  end

  def index
    @apps = App.all
  end

  private

  def app_params
    params.require(:app).permit(:name, :description, :link, :linux, :macos, :windows)
  end
end
