# frozen_string_literal: true

module Api
  module V1
    class TweetsController < ApplicationController
      def index # rubocop:disable Metrics/AbcSize
        count = Tweet.all.length
        current_page = params[:page].nil? ? 0 : params[:page].to_i
        tweets_limit = Tweet.limit(10).offset(current_page * 10).preload(:user)
        tweets = tweets_limit.map do |tweet|
          image = url_for(tweet.user.thumbnail) if tweet.user.thumbnail.attached?
          { tweet:, user: tweet.user, image: }
        end
        user_image = url_for(current_api_v1_user.thumbnail) if current_api_v1_user.thumbnail.attached?
        render json: { count:, tweets:, user_image: }
      end

      def show
        tweet = Tweet.find(params[:id])
        user = tweet.user
        user_image = url_for(user.thumbnail) if user.thumbnail.attached?
        render json: { tweet:, user:, user_image: }
      end

      def create
        tweet = current_api_v1_user.tweets.build(tweet_params)

        if tweet.save
          render json: tweet, status: :created
        else
          render json: tweet.errors, status: :unprocessable_entity
        end
        # render json: current_api_v1_user
      end

      def destroy
        tweet = Tweet.find(params[:id])
        tweet.destroy
        render json: tweet
      end

      def attach_image # rubocop:disable all
        tweet = current_api_v1_user.tweets.find(params[:id])
        tweet.update(tweet_params)
        tweet.update(image_url: url_for(tweet.image))
        render json: tweet.image
      end

      def comments # rubocop:disable all
        tweet = current_api_v1_user.tweets.build(tweet_params)
        tweet.comment_id = params[:tweet_id] if params[:tweet_id]

        if tweet.save
          render json: tweet, status: :created
        else
          render json: tweet.errors, status: :unprocessable_entity
        end
      end

      private

      def tweet_params
        params.require(:tweet).permit(:content, :image, :image_url)
      end
    end
  end
end
