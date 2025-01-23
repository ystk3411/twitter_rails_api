# frozen_string_literal: true

module Api
  module V1
    class NotificationsController < ApplicationController
      def index # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        notifications = current_api_v1_user.passive_notifications.eager_load(:visitor, :tweet).where.not(visitor_id: current_api_v1_user.id)
        notifications = notifications.map do |notification|
          datas = {}
          image = url_for(notification.visitor.thumbnail) if notification.visitor.thumbnail.attached?
          datas['notification'] = notification
          datas['user'] = User.find(notification.visitor_id) if notification.visitor_id.present?
          datas['tweet'] = Tweet.find(notification.tweet_id) if notification.tweet_id.present?
          datas['image'] = image
          datas
        end
        render json: notifications
      end
    end
  end
end
