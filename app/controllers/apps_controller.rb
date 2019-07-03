class AppsController < ApplicationController
  def show
    @app = App.find(params[:id])
    authorize(@app)
  end

  def new
    @app = App.new
    authorize(@app)
  end

  def create
    @app = App.new(app_params)
    authorize(@app)

    if @app.save
      @app.create_activity :create, owner: current_user
      redirect_to(app_path(@app.id), flash: { success: 'App created successfully' })
    else
      render 'new'
    end
  end

  # NOTE: create activity when adding #edit #update actions

  def index
    @apps = App.all
    authorize(App)
  end

  private

  def app_params
    params.require(:app).permit(:name, :description, :link, :linux, :macos, :windows)
  end
end
