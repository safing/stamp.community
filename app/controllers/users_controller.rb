class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    authorize(@user)
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

    if @user.update(permitted_attributes(@user))
      redirect_to user_path(@user)
    else
      render action: 'show'
    end
  end
end
