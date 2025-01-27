# frozen_string_literal: true

module Api
  module V1
    class RoomsController < ApplicationController
      def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        user = User.find(params[:id])
        current_user_entry = Entry.where(user_id: current_api_v1_user.id)
        user_entry = Entry.where(user_id: user.id)
        current_user_room_ids = current_user_entry.pluck(:room_id)
        user_room_ids = user_entry.pluck(:room_id)

        is_room = current_user_room_ids.intersect?(user_room_ids)

        return if is_room

        room = Room.create
        room.entries.create(user_id: current_api_v1_user.id)
        room.entries.create(user_id: params[:id])
        render json: room.entries
      end
    end
  end
end
