class MessagesController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    message = current_user.messages.build(message_params)
    if message.save
      redirect_to room_path(message.room)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def message_params
    params.require(:message).permit(:message, :room_id)
  end
end