class Public::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    @posts = @user.posts.order(created_at: :desc)
    @circles = @user.circles
    @circle_posts = Post.where(circle_id: @circles.pluck(:id)).order(created_at: :desc)
    @following_posts = Post.where(user_id: @user.followings.pluck(:id)).order(created_at: :desc)
    @rooms = @user.rooms.includes(:messages, :users)
    @following_count = @user.followings.where(is_active: true).count
    @follower_count = @user.followers.where(is_active: true).count

    # 以下DM機能用コントローラー
    @current_entry = Entry.where(user_id: current_user.id)
    @another_entry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @current_entry.each do |current|
        @another_entry.each do |another|
          if current.room_id == another.room_id
            @is_room = true
            @room_id = current.room_id
          end
        end
      end
      unless @is_room
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    @circles = @user.circles
    @following_count = @user.followings.where(is_active: true).count
    @follower_count = @user.followers.where(is_active: true).count
    if @user.update(user_params)
      flash.now[:notice] = "ユーザー情報を更新しました"
    else
      @user.reload
    end
  end

  def unsubscribe
    @user = current_user
  end

  def withdraw
    @user = current_user
    @user.update(is_active: false)
    reset_session
    flash[:notice] = "退会処理を実行しました"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :introduction, :user_image)
  end
end
