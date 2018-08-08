Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :domains, param: :name, constraints: { name: Domain::NAME_REGEX }, only: [:show]
  resources :labels, only: [:show]
  resources :licences, only: [:show]
  resources :stamps, except: [:delete]
  resources :users, only: [:show]

  mount APIRouter => '/'

  root to: 'application#index'
end
