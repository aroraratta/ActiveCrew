class Public::PermitsController < ApplicationController
  before_action :authenticate_user!

  def create
    @circle = Circle.find(params[:circle_id])
    permit = current_user.permits.new(circle_id: params[:circle_id])
    permit.save
    redirect_to request.referer, notice: "参加申請をしました"
  end

  def destroy
    circle = Circle.find(params[:circle_id])
    if circle.owner_id == current_user.id
      permit = Permit.find_by(params[:id])
    else
      permit = current_user.permits.find_by(circle_id: params[:circle_id])
    end

    permit.destroy
    redirect_to request.referer, alert: "参加申請を削除しました"
  end
end
