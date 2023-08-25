Rails.application.routes.draw do
  resources :items

  resources :feeds do
    collection do
      get :import_feeds, to: 'feeds#import_feeds'
      post :import_feeds, to: 'feeds#create_feeds'
    end
  end

  root "feeds#index"
  get '*path', to: 'feeds#index', via: :all
end
