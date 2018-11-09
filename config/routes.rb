require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  # resources :apps, only: %i[show new create]
  # resources :data_stamps, only: %i[show new create]
  get 'data_stamps/show'
  get 'data_stamps/new'
  get 'data_stamps/create'

  get 'apps/show'
  get 'apps/new'
  get 'apps/create'

  # rubocop:disable LineLength
  resources :domains, param: :name, constraints: { name: Domain::NAME_REGEX }, only: %i[show new create]
  # rubocop:enable LineLength
  resources :labels, only: [:show, :index]
  resources :licences, only: [:show]
  resources :users, only: [:show]

  resources :stamps, except: [:delete] do
    resources :comments, only: [:create]
    resources :votes, only: [:create]
  end

  mount APIRouter => '/'

  root to: 'stamps#index'
end
