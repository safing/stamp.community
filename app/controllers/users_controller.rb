class UsersController < ApplicationController
  def show
    @user = params[:id].to_i == -1 ? System.new : User.find(params[:id])
  end

  def index
    @users = User.all
  end
end
