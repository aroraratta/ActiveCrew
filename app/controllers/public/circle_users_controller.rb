class Public::CircleUsersController < ApplicationController
  before_action :authenticate_user_or_admin!
  before_action :ensure_owner, only: [:create]

  def index
    @circle = Circle.find(params[:circle_id])
    @circle_users = @circle.users.where.not(id: @circle.owner_id)
  end

  def create
    @permit = Permit.find(params[:permit_id])
    @circle_user = CircleUser.create(user_id: @permit.user_id, circle_id: params[:circle_id])
    @permit.destroy
    flash[:notice] = "#{@circle_user.user.name} の参加を許可しました"
    redirect_to request.referer
  end

  def destroy
    circle = Circle.find(params[:circle_id])
    circle_user = CircleUser.find_by(user_id: params[:id], circle_id: circle.id)
    if user_signed_in?
      if current_user.id == circle.owner_id || current_user.id == circle_user.user_id
        circle_user.destroy
        if current_user.id == circle_user.user_id
          flash[:notice] = "サークルを退出しました"
        else
          flash[:notice] = "#{circle_user.user.name} を退出"
        end
        redirect_to request.referer
      end

    elsif admin_signed_in?
      circle_user.destroy
      flash[:notice] = "#{circle_user.user.name} を退出"
      redirect_to request.referer
    end
  end
  
  def ensure_owner
    @circle = Circle.find(params[:circle_id])
    unless @circle.owner_id == current_user.id
      redirect_to circle_path(@circle)
    end
  end
end
