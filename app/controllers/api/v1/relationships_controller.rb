# frozen_string_literal: true

module Api
  module V1
    class RelationshipsController < ApplicationController
      def create # rubocop:disable Metrics/AbcSize
        relationship = Relationship.create(follower_id: current_api_v1_user.id,
                                           followed_id: params[:user_id])
        relationship.save
        user = User.find(params[:user_id])
        is_follow = true if user.passive_relationships.find_by(followed_id: params[:user_id])
        count_follow = user.active_relationships.count
        count_followers = user.passive_relationships.count
        render json: { is_follow:, count_follow:, count_followers: }
      end

      def destroy # rubocop:disable Metrics/AbcSize
        relationship = Relationship.find_by(follower_id: current_api_v1_user.id,
                                            followed_id: params[:user_id])
        relationship.destroy
        user = User.find(params[:user_id])
        is_follow = false unless user.passive_relationships.find_by(followed_id: params[:user_id])
        Rails.logger.debug Relationship.all
        count_follow = user.active_relationships.count
        count_followers = user.passive_relationships.count
        render json: { is_follow:, count_follow:, count_followers: }
      end
    end
  end
end
