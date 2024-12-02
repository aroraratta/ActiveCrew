class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user, except: [:show]

  def mypage
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
  end

  private

  def set_current_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :introduction, :user_image)
  end
end
