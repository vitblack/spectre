# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#home'
  devise_for :users, path: 'auth'

  resources :connections, only: %i[index new] do
    get :accounts, to: 'accounts#index'
    get :transactions, to: 'transactions#index'
  end
end
