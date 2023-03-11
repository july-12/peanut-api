Rails.application.routes.draw do
  resources :users do
    post :login, on: :collection
  end

  get 'user_info', to: 'application#user_info'
  get 'auth/github/callback', to: 'users#login_by_github'
  
  resources :courses, path: 'classes'
  resources :posts do
    get :weekly, on: :collection
  end
  resources :comments, only: [:index, :create]

  resources :tags, only: [:index, :create, :destroy] do
    post :batch, on: :collection
  end
  
end
