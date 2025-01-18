# frozen_string_literal: true

module Api
  module V1
    class FavoritesController < ApplicationController
      def create
        tweet = Tweet.find(params[:tweet_id])
        favorite = current_api_v1_user.favorites.build(tweet:)
        favorite.tweet_id = params[:tweet_id]
        favorite.save
        count_favorites = tweet.favorites.count
        render json: { favorite:, count_favorites: }
      end

      def destroy
        tweet = Tweet.find(params[:tweet_id])
        favorite = current_api_v1_user.favorites.find_by(tweet_id: params[:tweet_id])
        favorite.destroy
        count_favorites = tweet.favorites.count
        render json: { favorite:, count_favorites: }
      end
    end
  end
end
