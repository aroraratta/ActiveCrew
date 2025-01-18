class SearchesController < ApplicationController

  def search
    @range = params[:range]
    case @range
    when "user"
      search_users
    when "post"
      search_posts
    when "circle"
      search_circles
    else
      nil
    end
  end

  private

  # 管理者であればすべて検索可能、エンドユーザーであればis_activeのユーザーのみ検索可能
  def search_users
    scope = admin_signed_in? ? User : User.where(is_active: true)
    @users = scope.looks(params[:search], params[:word]).order(created_at: :desc)
  end

  def search_posts
    scope = admin_signed_in? ? Post : Post.joins(:user).where(users: { is_active: true })
    @posts = scope.looks(params[:search], params[:word]).order(created_at: :desc)
  end

  def search_circles
    @circles = Circle.looks_with_location(
                params[:search],
                params[:word],
                params[:prefecture_id],
                params[:city_id]
              ).order(created_at: :desc)
  end

end