class Public::CirclesController < ApplicationController
  before_action :authenticate_user_or_admin!, only: [:show, :update, :destroy]
  before_action :authenticate_user!, except: [:show, :update, :destroy]
  before_action :ensure_owner, only: [:edit, :update, :destroy]
  # admin側もpublic/circles#showのjsonの記述を使用するためauthenticate_user_or_admin!にshowを追加

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
    @events = @circle.events
    respond_to do |format|
      format.html
      format.json { render "calendar" }
    end
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
    if (user_signed_in? && @circle.owner_id == current_user.id) || admin_signed_in?
      @circle.destroy
      flash[:notice] = "サークルを削除しました"
      redirect_to user_signed_in? ? mypage_path : admin_circles_path
    else
      flash[:alert] = "サークル管理者のみサークルを削除できます"
      redirect_to circle_path(@circle)
    end
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
