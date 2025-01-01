class SearchesController < ApplicationController

  def search
    @range = params[:range]

    # 管理者であればすべて検索可能、ユーザーであればis_activeのユーザーのみ検索可能
    if admin_signed_in?
      case @range
      when "user"
        @users = User.looks(params[:search], params[:word]).order(created_at: :desc)
      when "post"
        @posts = Post.looks(params[:search], params[:word]).order(created_at: :desc)
      when "circle"
        @circles = Circle.looks_with_location(
          params[:search],
          params[:word],
          params[:prefecture_id],
          params[:city_id]
        ).order(created_at: :desc)
      else
        flash[:alert] = "不正な検索範囲が指定されました。"
        redirect_to top_path
      end
    else
      case @range
      when "user"
        @users = User.looks(params[:search], params[:word])
                      .where(is_active: true).order(created_at: :desc)
      when "post"
        @posts = Post.looks(params[:search], params[:word])
                      .joins(:user).where(users: { is_active: true }).order(created_at: :desc)
      when "circle"
        @circles = Circle.looks_with_location(
          params[:search],
          params[:word],
          params[:prefecture_id],
          params[:city_id]
        ).order(created_at: :desc)
      else
        flash[:alert] = "不正な検索範囲が指定されました。"
        redirect_to top_path
      end
    end
  end

end