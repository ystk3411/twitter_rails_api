# frozen_string_literal: true

module Api
  module V1
    class BookmarksController < ApplicationController
      def index # rubocop:disable Metrics/AbcSize
        bookmarks = current_api_v1_user.bookmarks.eager_load(:user, :tweet)
        tweets = bookmarks.map do |bookmark|
          image = url_for(bookmark.tweet.user.thumbnail) if bookmark.tweet.user.thumbnail.attached?
          datas = bookmark.tweet.as_json_with_details(current_api_v1_user)
          datas['image'] = image
          datas
        end
        user_image = url_for(current_api_v1_user.thumbnail) if current_api_v1_user.thumbnail.attached?
        render json: { tweets:, user_image: }
      end

      def create
        Rails.logger.debug params[:tweet_id]
        bookmark = current_api_v1_user.bookmarks.build(tweet_id: params[:tweet_id])
        bookmark.save
        render json: bookmark
      end

      def destroy
        Rails.logger.debug params
        bookmark = Bookmark.find(params[:id])
        bookmark.destroy
        render json: bookmark
      end
    end
  end
end
