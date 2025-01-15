# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      def show # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        user = User.find(params[:id])
        tweets = user.tweets.eager_load(user: { thumbnail_attachment: :blob }).preload(:retweets)
        tweets = tweets.map do |tweet|
          retweet_id = tweet.get_retweet_id(current_api_v1_user)
          count_retweet = tweet.retweets.count
          { tweet:, retweet_id:, user:, count_retweet: }
        end
        image_urls = {}
        image_urls[:header] = url_for(user.header) if user.header.attached?
        image_urls[:thumbnail] = url_for(user.thumbnail) if user.thumbnail.attached?
        render json: { user:, tweets:, image_urls: }
      end

      def update
        Rails.logger.debug params
        current_api_v1_user.update(user_params)
      end

      private

      def user_params
        params.require(:user).permit(:name, :comment, :header, :thumbnail, :profile, :web_site, :place, :birth_day)
      end
    end
  end
end
