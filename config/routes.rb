Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resource :users, only: [:create, :update]
  resource :sessions, only: [:create]
  resources :battles, only: [:new, :create, :index, :show]
  resources :battle_pets, only: [:create, :index, :show]

  namespace :hooks do
    resources :recruitments, only: :update
  end
end
