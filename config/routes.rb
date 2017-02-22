Rails.application.routes.draw do

  resources :emails, only: [:show, :create]

  resources :users, only: [] do
    resources :emails, only: [:index, :new]
  end
end
