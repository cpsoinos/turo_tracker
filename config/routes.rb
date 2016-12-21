require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'vehicles#index'
  mount Sidekiq::Web => '/sidekiq'

  resources :vehicles do
    get 'import', to: 'vehicles#import', as: 'import'
  end

  post '/:integration_name' => 'webhooks#receive', as: :receive_webhooks

end
