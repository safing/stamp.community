Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  mount APIRouter => '/'

  root to: 'application#index'
end
