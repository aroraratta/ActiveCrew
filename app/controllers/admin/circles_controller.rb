class Admin::CirclesController < ApplicationController
  before_action :authenticate_admin!
  before_action :ensure_circle, except: [:index]

  def index
    @circles = Circle.order(created_at: :desc)
  end

  def show
    @circle_posts = @circle.posts
    @prefectures = Prefecture.all
    @events = @circle.events
  end

  # updateアクションはpublic側のコントローラーを流用する
  # →非同期で実装しているため、jsファイルが増えて運用しにくくなることを防ぐため
  
  def destroy
    @circle.destroy
    flash[:notice] = "サークルを削除しました"
    redirect_to admin_circles_path
  end

  private

  def ensure_circle
    @circle = Circle.find(params[:id])
  end

  def circle_params
    params.require(:circle).permit(:circle_name, :circle_introduction, :circle_image, :prefecture_id,:city_id)
  end
end
