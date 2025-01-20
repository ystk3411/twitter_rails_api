# frozen_string_literal: true

class Relationship < ApplicationRecord
  include Notificationable
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  def notification_create_invalid?
    User.find(follower_id).id == visited_id
  end

  def visited_id
    followed_id
  end
end
