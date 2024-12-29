class Admin::EventsController < ApplicationController
  def show
    @circle = Circle.find(params[:circle_id])
    @event = Event.find(params[:id])
    @attends = @event.attends.includes(:user)
  end
end
