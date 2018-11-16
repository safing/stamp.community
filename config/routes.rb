require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :apps, only: %i[show new create]
  # rubocop:disable LineLength
  resources :domains, param: :name, constraints: { name: Domain::NAME_REGEX }, only: %i[show new create]
  # rubocop:enable LineLength
  resources :labels, only: %i[show index]
  resources :licences, only: [:show]
  resources :users, only: [:show]

  # neat patterns for different Stamp::TYPES =>
  #  Prefix                URI Pattern                       Controller#Action
  # flag_stamp_index       /flag_stamps(.:format)            stamps/flags#index
  #  new_label_stamp       /label_stamps/new(.:format)       stamps/labels#new
  Stamp::TYPES.map { |t| t.demodulize.underscore }.each do |type|
    resources type,
              controller: "stamps/#{type.pluralize}",
              as: "#{type}_stamp",
              path: "#{type}_stamps",
              except: :destroy
  end

  # voting & commenting on a stamp makes no difference of the stamp#type, they only needs an :id
  scope 'stamps/:id', as: :stamp do
    resources :comments, only: [:create]
    resources :votes, only: [:create]
  end

  mount APIRouter => '/'

  root to: 'stamps/labels#index'
end
