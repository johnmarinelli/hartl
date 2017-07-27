Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  resources :users
  resources :microposts, only: [:create, :destroy]
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  get 'sessions/new'

  get '/help', to: 'static_pages#help'

  get '/about', to: 'static_pages#about'

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  post '/edit_user', to: 'users#update'
  delete '/logout', to: 'sessions#destroy'

  root 'static_pages#home'
end
