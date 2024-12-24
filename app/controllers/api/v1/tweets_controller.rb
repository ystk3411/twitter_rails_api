# frozen_string_literal: true

module Api
  module V1
    class TweetsController < ApplicationController
      def index # rubocop:disable Metrics/AbcSize
        count = Tweet.all.length
        current_page = params[:page].nil? ? 0 : params[:page].to_i
        tweets_limit = Tweet.limit(10).offset(current_page * 10).preload(:user)
        tweets = tweets_limit.map do |tweet|
          { tweet:, user: tweet.user, image: tweet.user.image }
        end
        render json: { count:, tweets: }
      end

      def show
        tweet = Tweet.find(params[:id])
        user = tweet.user
        render json: { tweet:, user: }
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

      def attach_image # rubocop:disable all
        tweet = current_api_v1_user.tweets.find(params[:id])
        tweet.update(tweet_params)
        tweet.update(image_url: url_for(tweet.image))
        render json: tweet.image
      end

      def limit_tweets # rubocop:disable all
        current_page = params[:page].nil? ? 0 : params[:page].to_i
        tweets = Tweet.limit(10).offset(current_page * 10)
        data = tweets.map { |tweet| { tweet:, user: tweet.user, image: tweet.user.image } }
        # users = tweets.map{ |tweet| tweet.user}
        render json: data
      end

      private

      def tweet_params
        params.require(:tweet).permit(:content, :image, :image_url)
      end
    end
  end
end
