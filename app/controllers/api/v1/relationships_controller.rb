class Api::V1::RelationshipsController < ApplicationController
  def create
    relationship = Relationship.create(follower_id: current_api_v1_user.id,
                                         followed_id: params[:user_id])
    relationship.save
    render json: relationship
  end
end
