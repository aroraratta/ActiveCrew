class Public::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :update]

  def show
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    @posts = @user.posts.order(created_at: :desc)
    @circles = @user.circles
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
    if admin_signed_in?
      @user = User.find(params[:id])
    elsif authenticate_user!
      @user = current_user
    end

    if @user.update(user_params)
      flash[:notice] = "ユーザー情報を更新しました。"
      redirect_to user_path(@user)
    else
      @posts = @user.posts.order(created_at: :desc)
      render :show
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
