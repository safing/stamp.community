require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :domains, param: :name, constraints: { name: Domain::NAME_REGEX }, only: %i[show new]
  resources :labels, only: [:show]
  resources :licences, only: [:show]
  resources :stamps, except: [:delete] do
    resources :comments
  end
  resources :users, only: [:show]

  mount APIRouter => '/'

  root to: 'stamps#index'
end
