Rails.application.routes.draw do
  devise_for :users
  root "static#show", page: "home"
  get "/yelp_search", to: "static#show", page: "yelp_search"
  resources :events, only: [:index,:update, :create]
end
