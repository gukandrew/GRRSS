Rails.application.routes.draw do
  namespace :api do
    resources :items, only: %i[index]

    resources :feeds, only: %i[index update destroy] do
      collection do
        get :import_feeds, to: 'feeds#import_feeds'
        post :import_feeds, to: 'feeds#create_feeds'
      end
    end

    resources :statistics, only: %i[index]
  end

  root "homepage#index"
  get '*path', to: 'homepage#index', via: :all
end
