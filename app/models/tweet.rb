# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :comments, class_name: 'Tweet', foreign_key: 'comment_id', dependent: :destroy, inverse_of: :tweet
  belongs_to :tweet, class_name: 'Tweet', foreign_key: 'comment_id', optional: true, inverse_of: :comments
  has_many :retweets, dependent: :destroy

  def retweeted_by?(user)
    retweets.where(user_id: user.id).exists?
  end

  def retweet_id(user)
    retweets.where(user_id: user.id)[0].id if retweets.where(user_id: user.id).exists?
  end
end
