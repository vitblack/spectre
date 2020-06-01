# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#home'
  devise_for :users, path: 'auth'

  resources :connections, only: %i[index new destroy] do
    get :accounts, to: 'accounts#index'
    get :transactions, to: 'transactions#index'
  end

  namespace :api, defaults: { format: 'json' } do
    resources :callbacks, only: [] do
      post :fail, on: :collection
      post :success, on: :collection
    end
  end
end
