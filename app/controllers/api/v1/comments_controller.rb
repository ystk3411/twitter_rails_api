# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApplicationController
      def index # rubocop:disable Metrics/AbcSize
        tweet = Tweet.find(params[:id])
        comments = tweet.comments.eager_load(user: { thumbnail_attachment: :blob }).preload(:retweets)
        comments = comments.map do |comment|
          thumbnail = url_for(comment.user.thumbnail) if comment.user.thumbnail.attached?
          retweet_id = comment.get_retweet_id(current_api_v1_user)
          count_retweet = comment.retweets.count
          { comment:, user: comment.user, thumbnail:, retweet_id:, count_retweet: }
        end
        render json: comments
      end
    end
  end
end
