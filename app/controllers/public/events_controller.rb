class Public::EventsController < ApplicationController
  before_action :authenticate_user_or_admin!, only: [:show, :update, :destroy]
  before_action :authenticate_user!, except: [:show, :update, :destroy]
  before_action:set_time_zone

  def new
    @circle = Circle.find(params[:circle_id])
    @event = @circle.events.build(start: Time.now, end: Time.now + 1.hour)
  end
  
  def create
    @circle = Circle.find(params[:circle_id])
    @event = @circle.events.build(event_params)
  
    if @event.save
      flash[:notice] = "イベントを作成しました"
      redirect_to circle_path(@circle)
    else
      render :new
    end
  end

  def show
    @circle = Circle.find(params[:circle_id])
    @event = Event.find(params[:id])
    @attends = @event.attends.includes(:user)
  end

  def destroy
    circle = Circle.find(params[:circle_id])
    event = Event.find(params[:id])
    if (user_signed_in? && event.circle.owner_id == current_user.id) || admin_signed_in?
      event.destroy
      flash[:notice] = "イベントを削除しました"
      redirect_to user_signed_in? ? circle_path(circle) : admin_circle_path(circle)
    else
      flash[:alert] = "サークル管理者のみイベントを削除できます"
      redirect_to circle_event(circle_id: circle, id: event)
    end
  end


  private

  def event_params
    params.require(:event).permit(:event_title, :event_place, :event_memo, :start, :end)
  end
  
  def set_time_zone
    Time.zone = "Asia/Tokyo"
  end
  
end
