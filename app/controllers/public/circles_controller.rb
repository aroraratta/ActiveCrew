class Public::CirclesController < ApplicationController
  before_action :authenticate_user_or_admin!, only: [:update]
  before_action :authenticate_user!, except: [:update]
  before_action :ensure_owner, only: [:edit, :update, :destroy]

  def new
    @circle = Circle.new
    @prefectures = Prefecture.all
  end

  def create
    @prefectures = Prefecture.all
    @circle = Circle.new(circle_params)
    @circle.owner_id = current_user.id
    if @circle.save
      CircleUser.create(user_id: current_user.id, circle_id: @circle.id)
      flash[:notice] = "サークルを作成しました"
      redirect_to circle_path(@circle)
    else
      render "new"
    end
  end

  def show
    @circle = Circle.find(params[:id])
    @circle_posts = @circle.posts
    @prefectures = Prefecture.all
    @permits = @circle.permits
  end

  def update
    @prefectures = Prefecture.all
    if @circle.update(circle_params)
      flash.now[:notice] = "サークルを編集しました"
    else
      flash.now[:alert] = "サークルの編集に失敗しました"
    end
  end
  
  def destroy
    @circle.destroy
    flash[:notice] = "サークルを削除しました"
    redirect_to mypage_path
  end

  private

  def ensure_owner
    @circle = Circle.find(params[:id])
    if user_signed_in?
      unless @circle.owner_id == current_user.id
        redirect_to circles_path
      end
    end
  end

  def circle_params
    params.require(:circle).permit(:circle_name, :circle_introduction, :circle_image, :prefecture_id, :city_id)
  end
end
