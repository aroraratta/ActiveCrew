class Public::UsersController < ApplicationController
  before_action :authenticate_user_or_admin!, only: [:update]
  before_action :authenticate_user!, except: [:update]

  def show
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    @posts = @user.posts.order(created_at: :desc)
    @circles = @user.circles
    @circle_posts = Post.where(circle_id: @circles.ids).order(created_at: :desc)
    @following_posts = Post.joins(:user).where(users: { id: @user.followings.ids }).order(created_at: :desc)
    # 新しいメッセージがあるDMルームをソートするため必要
    @rooms = @user.rooms.joins(:messages).select('rooms.*, MAX(messages.created_at) as last_message_time').group('rooms.id').order('last_message_time DESC').includes(:messages)
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
    if current_user.id != 1
      @user = current_user
      @user.update(is_active: false)
      reset_session
      flash[:notice] = "退会処理を実行しました"
      redirect_to root_path
    else
      redirect_to unsubscribe_path
      flash[:alert] = "ゲストユーザーは退会できません。"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :introduction, :user_image, :is_active)
  end
end
