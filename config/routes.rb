Rails.application.routes.draw do

  
  get 'searches/index'
  get 'searches/search'
  get 'top/index'
  root 'top#index'
  get "search" => "searches#search"

  get 'likes/create'
  get 'likes/destroy'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  

  get 'users/show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :spots
  patch '/spots/:id', to: 'spots#update', as: 'update_spot'
  
  
end
