# frozen_string_literal: true

module Api
  module V1
    class TweetsController < ApplicationController
      def index
        tweets = Tweet.all
        current_page = params[:page].nil? ? 0 : params[:page].to_i
        limited_params = Tweet.limit(10).offset(current_page * 10)
        render json: tweets
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
        render json: tweet.image
      end

      def limit_tweets # rubocop:disable all
        current_page = params[:page].nil? ? 0 : params[:page].to_i
        tweets = Tweet.limit(10).offset(current_page * 10)
        data = tweets.map{ |tweet| {tweet: tweet, user: tweet.user, image: tweet.user.image}}
        # users = tweets.map{ |tweet| tweet.user}
        render json: data
      end

      private

      def tweet_params
        params.require(:tweet).permit(:content, :image)
      end
    end
  end
end
