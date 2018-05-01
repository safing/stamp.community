Rails.application.routes.draw do
  devise_for :users
  mount APIRouter => '/'

  root to: 'application#index'
end
