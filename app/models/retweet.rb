# frozen_string_literal: true

class Retweet < ApplicationRecord
  include Notificationable
  belongs_to :user
  belongs_to :tweet

  def notification_create_invalid?
    User.find(user_id).id == visited_id
  end

  def visited_id
    tweet.present? ? tweet.user.id : 0
  end
end
