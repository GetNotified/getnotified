Rails.application.routes.draw do
  resources :notifications

  resources :services

  devise_for :users

  root to: "home#index"

  get 'home/index'
end
