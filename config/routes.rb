require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  # rubocop:disable LineLength
  resources :domains, param: :name, constraints: { name: Domain::NAME_REGEX }, only: %i[show new create]
  # rubocop:enable LineLength
  resources :labels, only: [:show, :index]
  resources :licences, only: [:show]
  resources :stamps, except: [:delete] do
    resources :comments, only: [:create]
    resources :votes, only: [:create]
  end
  resources :users, only: [:show]

  mount APIRouter => '/'

  root to: 'stamps#index'
end
