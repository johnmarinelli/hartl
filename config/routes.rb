Rails.application.routes.draw do
  resources :users
  resources :microposts
  resources :account_activations, only: [:edit]
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
