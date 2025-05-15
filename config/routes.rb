Rails.application.routes.draw do
  resources :users, only: [:index, :show]
  devise_for :users
  resources :books
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: "books#index"
end
