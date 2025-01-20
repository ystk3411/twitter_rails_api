# frozen_string_literal: true

Rails.application.routes.draw do
  # mount_devise_token_auth_for 'User', at: 'auth'
  namespace :api do
    namespace :v1 do
      resources :tweets do
        resources :retweets
        resources :favorites
      end

      resources :users do
        post 'follow', to: 'relationships#create'
        delete 'unfollow', to: 'relationships#destroy'
      end
      post 'image', to: 'tweets#attach_image'
      post 'limit_tweets', to: 'tweets#limit_tweets'
      post 'comments', to: 'tweets#comments'
      get 'user/:id', to: 'users#show'
      put 'profile', to: 'users#update'
      resources :comments, only: :index

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
