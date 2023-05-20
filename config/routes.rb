Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  get 'searches/index'
  get 'searches/search'
  get 'top/index'
  root 'top#index'
  get "search" => "searches#search"

  get 'likes/create'
  get 'likes/destroy'

  get 'users/show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :spots 
end
