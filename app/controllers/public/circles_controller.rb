class Public::CirclesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_owner, only: [:edit, :update]

  def new
    @circle = Circle.new
    @prefectures = Prefecture.all
  end

  def create
    @prefectures = Prefecture.all
    @circle = Circle.new(circle_params)
    @circle.owner_id = current_user.id
    if @circle.save
      redirect_to circle_path(@circle)
    else
      render "new"
    end
  end

  def show
    @circle = Circle.find(params[:id])
    @circle_posts = @circle.posts
  end

  def edit
  end

  def update
    if @circle.update(circle_params)
      redirect_to circle_path
    else
      render "edit"
    end
  end

  private

  def ensure_owner
    @circle = Circle.find(params[:id])
    unless @circle.owner_id == current_user.id
      redirect_to circles_path
    end
  end

  def circle_params
    params.require(:circle).permit(:circle_name, :circle_introduction, :circle_image, :prefecture_id,:city_id)
  end
end
