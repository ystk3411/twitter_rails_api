# frozen_string_literal: true

Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  # mount_devise_token_auth_for 'User', at: 'auth'
  namespace :api do # rubocop:disable Metrics/BlockLength
    namespace :v1 do # rubocop:disable Metrics/BlockLength
      resources :tweets do
        resources :retweets
        resources :favorites
      end

      resources :users, only: %w[show] do
        post 'follow', to: 'relationships#create'
        delete 'unfollow', to: 'relationships#destroy'
      end
      post 'image', to: 'tweets#attach_image'
      post 'limit_tweets', to: 'tweets#limit_tweets'
      post 'comments', to: 'tweets#comments'
      get 'user/:id', to: 'users#show'
      put 'profile', to: 'users#update'
      post 'groups', to: 'rooms#create'
      post 'groups/:group_id/messages', to: 'messages#create'
      post 'messages_image', to: 'messages#attach_image'
      get ':group_id/messages', to: 'messages#show'
      get 'groups', to: 'messages#index'
      resources :comments, only: :index
      resources :notifications, only: :index
      resources :messages, only: %w[index create show]
      resources :rooms, only: %w[create]
      resources :bookmarks, only: %w[index create destroy]

      mount_devise_token_auth_for 'User', at: 'users', controllers: {
        registrations: 'api/v1/users/registrations'
      }
    end
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'tasks#index'
end
