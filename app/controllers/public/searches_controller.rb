class Public::SearchesController < ApplicationController

  # 管理者であればすべて検索可能、ユーザーであればis_activeのユーザーのみ検索可能
  def search
    @range = params[:range]
    if @range == "user"
      @users = User.looks(params[:search], params[:word]).where(is_active: true).order(created_at: :desc)
    elsif @range == "post"
      @posts = Post.looks(params[:search], params[:word]).joins(:user).where(users: { is_active: true }).order(created_at: :desc)
    elsif
      @circles = Circle.looks(params[:search], params[:word]).order(created_at: :desc)
    else
      flash[:alert] = "不正な検索範囲が指定されました。"
      redirect_to top_path
    end
  end

end
