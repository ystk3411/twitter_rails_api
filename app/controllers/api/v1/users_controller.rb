# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      def show # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        user = User.find(params[:id])
        tweets = user.tweets.eager_load(user: { thumbnail_attachment: :blob }).preload(:retweets)
        tweets = tweets.map do |tweet|
          datas = tweet.as_json_with_details(current_api_v1_user)
          datas
        end
        image_urls = {}
        image_urls[:header] = url_for(user.header) if user.header.attached?
        image_urls[:thumbnail] = url_for(user.thumbnail) if user.thumbnail.attached?
        is_follow = true if current_api_v1_user.active_relationships.find_by(followed_id: params[:id])
        count_follow = user.active_relationships.count
        count_followers = user.passive_relationships.count
        render json: { user:, tweets:, image_urls:, is_follow:, count_follow:, count_followers: }
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
