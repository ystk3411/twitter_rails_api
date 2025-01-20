module Notificationable
  extend ActiveSupport::Concern

  included do
    after_create :create_notification!
  end

  def create_notification!
    return if notification_create_invalid?
    tweet_id = comment_id if self.class.to_s == 'Tweet'
    visitor_id = ""
    if self.class.to_s == 'Relationship' 
      visitor_id = follower_id
    else
      visitor_id = user_id
    end
    # visited_id = followed_id if self.class.to_s == 'Relationship'
    # user_id = followed_id if self.class.to_s == 'Relationship'

    temp = Notification.where(visitor_id: visitor_id, visited_id: visited_id, tweet_id: tweet_id, action_type: self.class.to_s.downcase)

    return if temp.present?

    notification = ""

    if self.class.to_s == 'Relationship' 
      notification = User.find(visitor_id).active_notifications.new(
      tweet_id: nil,
      visited_id:,
      action_type: self.class.to_s.downcase
    )
    else
      notification = User.find(visitor_id).active_notifications.new(
      tweet_id: tweet.id,
      visited_id:,
      action_type: self.class.to_s.downcase
    )
    end

    # notification = User.find(visitor_id).active_notifications.new(
    #   tweet_id: tweet.id,
    #   visited_id:,
    #   action_type: self.class.to_s.downcase
    # )

    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end
end