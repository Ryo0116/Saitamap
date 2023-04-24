Rails.application.routes.draw do
  get 'top/index'
  devise_for :users
  root 'top#index'

  get 'likes/create'
  get 'likes/destroy'

  get 'users/new'
  get 'users/show'
  get 'sessions/new'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :spots 
end
