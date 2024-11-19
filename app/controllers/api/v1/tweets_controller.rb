class Api::V1::TweetsController < ApplicationController
  def create
    tweet = current_api_v1_user.tweets.build(tweet_params)

    if tweet.save
      render json: tweet, status: :created
    else
      render json: tweet.errors, status: :unprocessable_entity
    end
    # render json: current_api_v1_user
  end

  def attach_image
    tweet = Tweet.find(params[:id])
    tweet.update(tweet_params)
    render json: tweet.image
  end

  private

  def tweet_params
    params.require(:tweet).permit(:content, :image)
  end
end
