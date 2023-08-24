Rails.application.routes.draw do
  resources :items
  resources :feeds
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "feeds#index"
end
