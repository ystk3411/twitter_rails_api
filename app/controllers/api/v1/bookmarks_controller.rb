class Api::V1::BookmarksController < ApplicationController
  def index
    bookmarks = current_api_v1_user.bookmarks.eager_load(:user, :tweet)
    render json: bookmarks
  end

  def create
    p params[:tweet_id]
    bookmark = current_api_v1_user.bookmarks.build(tweet_id: params[:tweet_id])
    bookmark.save
    render json: bookmark
  end

  def destroy
    p params
    bookmark = Bookmark.find(params[:id])
    bookmark.destroy
    render json: bookmark
  end
end
