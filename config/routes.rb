Rails.application.routes.draw do

  get '/', to: 'tests#new'
  resources :users, only: [:create] do
    resource :autocrypt, only: [:create, :show, :update]
    resources :emails, only: [:index, :show, :new, :create]
  end
end
