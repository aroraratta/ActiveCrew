class Admin::EventsController < ApplicationController
  before_action :authenticate_admin!
  def show
    @circle = Circle.find(params[:circle_id])
    @event = Event.find(params[:id])
    @attends = @event.attends.includes(:user)
  end
end
