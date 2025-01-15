# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :comments, class_name: 'Tweet', foreign_key: 'comment_id', dependent: :destroy, inverse_of: :tweet
  belongs_to :tweet, class_name: 'Tweet', foreign_key: 'comment_id', optional: true, inverse_of: :comments
  has_many :retweets, dependent: :destroy
  has_many :favorites, dependent: :destroy

  def retweeted_by?(user)
    retweets.exists?(user_id: user.id)
  end

  def get_retweet_id(user)
    retweets.find_by(user_id: user.id)&.id
  end

  def get_favorite_id(user)
    favorites.find_by(user_id: user.id)&.id
  end

  def as_json_with_details(current_user)
    {
      tweet: self,
      retweet_id: get_retweet_id(current_user),
      favorite_id: get_favorite_id(current_user),
      user:,
      count_retweet: retweets.count,
      count_favorite: favorites.count
    }
  end
end
