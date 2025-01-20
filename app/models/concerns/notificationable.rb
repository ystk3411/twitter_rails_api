# frozen_string_literal: true

module Notificationable
  extend ActiveSupport::Concern

  included do
    after_create :create_notification!
  end

  def create_notification! # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    return if notification_create_invalid?

    tweet_id = comment_id if instance_of?(::Tweet)
    visitor_id = if instance_of?(::Relationship)
                   follower_id
                 else
                   user_id
                 end

    temp = Notification.where(visitor_id:, visited_id:, tweet_id:,
                              action_type: self.class.to_s.downcase)

    return if temp.present?

    notification = if instance_of?(::Relationship)
                     User.find(visitor_id).active_notifications.new(
                       tweet_id: nil,
                       visited_id:,
                       action_type: self.class.to_s.downcase
                     )
                   else
                     User.find(visitor_id).active_notifications.new(
                       tweet_id: tweet.id,
                       visited_id:,
                       action_type: self.class.to_s.downcase
                     )
                   end

    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end
end
