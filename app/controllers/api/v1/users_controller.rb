class Api::V1::UsersController < ApplicationController
  def show
    user = User.find(params[:id])
    tweets = user.tweets
    image_urls = {}
    image_urls[:header] = url_for(user.header) if user.header.attached?
    image_urls[:thumbnail] = url_for(user.thumbnail) if user.thumbnail.attached?
    render json: {user: , tweets: , image_urls: }
  end

  def update
    puts params
    current_api_v1_user.update(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:name, :comment, :header, :thumbnail, :profile, :web_site, :place, :birth_day)
  end
end
