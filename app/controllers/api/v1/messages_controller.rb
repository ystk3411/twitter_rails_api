# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
      def index # rubocop:disable Metrics/AbcSize
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

      def show # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
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

        return if Entry.where(user_id: current_api_v1_user.id, room_id: room.id).blank?

        messages = room.messages
        entries = room.entries
        another_entry = entries.find_by('user_id != ?', current_api_v1_user.id)
        another_entry_info = {}
        another_entry_info['entry'] = another_entry
        another_entry_info['user'] = another_entry.user
        if another_entry.user.thumbnail.attached?
          another_entry_info['thumbnail'] =
            url_for(another_entry.user.thumbnail)
        end
        render json: { messages:, entries_info:, another_entry_info: }
      end

      def create
        Rails.logger.debug params[:image]
        message = Message.create!(user_id: current_api_v1_user.id, room_id: params[:group_id],
                                  content: params[:content])
        render json: message
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
  end
end
