require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'vehicles#index'
  mount Sidekiq::Web => '/sidekiq'

  resources :vehicles do
    get 'import', to: 'vehicles#import', as: 'import'
    resources :trips, only: [:index]
    resources :tolls, only: [:index]
    resources :expenses
    resources :reservations do
      resources :tolls
      resources :trips
    end
  end

  get '/dashboard', to: 'reporting#dashboard', as: 'dashboard'
  post '/import-data', to: 'reporting#import_data', as: 'import_data'

  post '/:integration_name' => 'webhooks#receive', as: :receive_webhooks

end
