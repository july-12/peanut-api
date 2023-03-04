Rails.application.routes.draw do
  resources :users do
    post :login, on: :collection
  end
  
  resources :courses, path: 'class'
  resources :posts do
    resources :comments
  end
  
end
