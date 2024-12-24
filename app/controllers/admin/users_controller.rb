class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.order(created_at: :desc)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
    @circles = @user.circles
    @following_count = @user.followings.where(is_active: true).count
    @follower_count = @user.followers.where(is_active: true).count
  end
  
  # updateアクションはpublic側のコントローラーを流用する
  # →非同期で実装しているため、jsファイルが増えて運用しにくくなることを防ぐため
  
end