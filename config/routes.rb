Rails.application.routes.draw do
  resources :users do
    post :login, on: :collection
  end

  get 'user_info', to: 'application#user_info'

  get 'auth/github/callback', to: 'users#login_by_github'
  
  resources :courses, path: 'class'
  resources :posts do
    resources :comments
  end
  
end
