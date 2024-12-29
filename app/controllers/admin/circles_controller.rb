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

  # update,destroyアクションはpublic側のコントローラーを流用する
  
  private

  def ensure_circle
    @circle = Circle.find(params[:id])
  end
end
