class Api::V1::RoomsController < ApplicationController
  def create
    user = User.find(params[:id])
    current_user_entry = Entry.where(user_id:current_api_v1_user.id)
    user_entry = Entry.where(user_id: user.id)
    current_user_room_ids =current_user_entry.pluck(:room_id)
    user_room_ids = user_entry.pluck(:room_id)

    if (current_user_room_ids & user_room_ids).present?
      is_room = true
    else
      is_room = false
    end

    return if is_room

    room = Room.create
    room.entries.create(user_id: current_api_v1_user.id)
    room.entries.create(user_id: params[:id])
    render json: room.entries
  end
end
