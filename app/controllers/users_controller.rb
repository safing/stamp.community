class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
    authorize(@user)
    render action: 'show'
  end

  def update
    @user = User.find(params[:id])
    authorize(@user)

    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render action: 'show'
    end
  end

  private

  def user_params
    params.require(:user).permit(:description)
  end
end
