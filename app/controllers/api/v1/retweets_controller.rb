# frozen_string_literal: true

module Api
  module V1
    class RetweetsController < ApplicationController
      def create
        retweet = current_api_v1_user.retweets.build(tweet_id: params[:tweet_id])
        retweet.save
        tweet = Tweet.find(params[:tweet_id])
        count_retweets = tweet.retweets.count
        render json: { retweet:, count_retweets: }
      end

      def destroy
        retweet = current_api_v1_user.retweets.find_by(tweet_id: params[:tweet_id])
        retweet.destroy
        tweet = Tweet.find(params[:tweet_id])
        count_retweets = tweet.retweets.count
        render json: { retweet:, count_retweets: }
      end
    end
  end
end
