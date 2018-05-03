Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :domains, param: :name, constraints: { name: Domain::NAME_REGEX }, only: [:show]
  resources :stamps, only: [:show]
  resources :users, only: [:show]

  mount APIRouter => '/'

  root to: 'application#index'
end
