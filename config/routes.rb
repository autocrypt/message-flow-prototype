Rails.application.routes.draw do

  resources :emails, only: [:show, :create]

  resources :users, only: [:show] do
    resource :settings, only: [:show, :update]
    resources :emails, only: [:index, :new]
  end
end
