Rails.application.routes.draw do

  resources :users, only: [] do
    resource :autocrypt, only: [:create, :show, :update]
    resources :emails, only: [:index, :show, :new, :create]
  end
end
