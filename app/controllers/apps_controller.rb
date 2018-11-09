class AppsController < ApplicationController
  def show
    @app = App.find(params[:id])
  end

  def new
    @app = App.new
  end

  def create; end
end
