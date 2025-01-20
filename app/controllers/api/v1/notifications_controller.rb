class Api::V1::NotificationsController < ApplicationController
  def index
    notifications = current_api_v1_user.passive_notifications.where.not(visitor_id: current_api_v1_user.id)
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
