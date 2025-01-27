class Api::V1::MessagesController < ApplicationController
  def index
    my_room_ids = current_api_v1_user.entries.pluck(:room_id)

    another_entries = Entry.preload(:user).where(room_id: my_room_ids).where.not(user_id: current_api_v1_user.id)

    entries_info = another_entries.map do |entry|
      data = {}
      data['entry'] = entry
      data['user'] = entry.user
      data['thumbnail'] = url_for(entry.user.thumbnail) if entry.user.thumbnail.attached?
      data
    end

    render json: entries_info
  end

  def create
    p params[:image]
    message = Message.create!(user_id: current_api_v1_user.id, room_id: params[:group_id], content: params[:content])
    render json: message
  end

  def show
    my_room_ids = current_api_v1_user.entries.pluck(:room_id)

    another_entries = Entry.preload(:user).where(room_id: my_room_ids).where.not(user_id: current_api_v1_user.id)
    room = Room.find(params[:group_id])

    entries_info = another_entries.map do |entry|
      data = {}
      data['entry'] = entry
      data['user'] = entry.user
      data['thumbnail'] = url_for(entry.user.thumbnail) if entry.user.thumbnail.attached?
      data
    end

    if Entry.where(user_id: current_api_v1_user.id, room_id: room.id).present?
      messages = room.messages
      entries = room.entries
      another_entry = entries.find_by('user_id != ?', current_api_v1_user.id)
      another_entry_info = {}
      another_entry_info['entry'] = another_entry
      another_entry_info['user'] = another_entry.user
      another_entry_info['thumbnail'] = url_for(another_entry.user.thumbnail) if another_entry.user.thumbnail.attached?
      render json: {messages:, entries_info:, another_entry_info:}
    else
      return
    end
  end

  def attach_image # rubocop:disable all
    message = current_api_v1_user.messages.find(params[:id])
    message.update(message_params)
    message.update(image_url: url_for(message.image))
    render json: message
  end

  private

  def message_params
    params.require(:message).permit(:content, :image, :image_url)
  end
end
