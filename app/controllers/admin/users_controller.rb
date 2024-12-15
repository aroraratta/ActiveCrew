class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.order(created_at: :desc)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "ユーザー情報を更新しました。"
      redirect_to admin_user_path(@user)
    else
      @posts = @user.posts.order(created_at: :desc)
      render :show
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :introduction, :user_image, :is_active)
  end
end