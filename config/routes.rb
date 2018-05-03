Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users, only: [:show]

  mount APIRouter => '/'

  root to: 'application#index'
end
