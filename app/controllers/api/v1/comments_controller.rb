# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApplicationController
      def index
        tweet = Tweet.find(params[:id])
        comments = tweet.comments.eager_load(user: { thumbnail_attachment: :blob })
        comments = comments.map do |comment|
          thumbnail = url_for(comment.user.thumbnail) if comment.user.thumbnail.attached?
          { comment:, user: comment.user, thumbnail: }
        end
        render json: comments
      end
    end
  end
end