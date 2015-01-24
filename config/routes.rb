Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'sessions#landing'
  get '/home', to: 'videos#index'
  
  resources :videos, only: [:create, :new, :show] do
    post 'search', on: :collection
  end
  resources :categories, only: [:create, :new, :show]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/register', to: 'users#new'
  resources :users, only: [:show, :create, :edit, :update]

end
