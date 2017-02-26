Rails.application.routes.draw do

  resources :users, only: [:show] do
    resource :settings, only: [:show, :update]
    resources :emails, only: [:index, :show, :new, :create]
  end
end
