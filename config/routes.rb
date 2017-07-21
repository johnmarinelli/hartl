Rails.application.routes.draw do
  get '/help', to: 'static_pages#help'

  get '/about', to: 'static_pages#about'

  get '/login', to: 'users#login'

  get '/signup', to: 'users#new'

  resources :microposts
  resources :users
  root 'static_pages#home'
end
