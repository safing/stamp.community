require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :apps, only: %i[show new create index]
  # rubocop:disable LineLength
  resources :domains, param: :name, constraints: { name: Domain::NAME_REGEX }, only: %i[show new create index]
  # rubocop:enable LineLength
  resources :labels, only: %i[show index]
  resources :licences, only: %i[show index]
  resources :users, only: %i[show index]

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

  # rubocop:disable LineLength
  post 'notifications/read_all', to: 'notifications#read_all', as: :read_all_notifications, constraints: { format: :js }
  # rubocop:enable LineLength

  mount APIRouter => '/'
  get 'terms', to: 'static#terms', as: :tos

  scope :guides do
    get 'tour', to: 'guides#tour', as: :tour
    get 'label_stamps', to: 'guides#label_stamps', as: :label_stamps_guide
  end

  scope :redirect do
    get '/forums', to: redirect('https://discourse.safing.community/c/stamp'), as: :forums
    get '/uMatrix', to: redirect('https://github.com/gorhill/uMatrix'), as: :umatrix
  end

  root to: 'guides#tour'
end
