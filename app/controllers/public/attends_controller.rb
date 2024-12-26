class Public::AttendsController < ApplicationController
  def create
    event = Event.find(params[:event_id])
    attend = current_user.attends.new(event_id: event.id)
    attend.save
    redirect_to request.referer
  end
  
  def destroy
    event = Event.find(params[:event_id])
    attend = current_user.attends.find_by(event_id: event.id)
    attend.destroy
    redirect_to request.referer
  end
end
