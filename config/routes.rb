Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'        # redirects to front page which will redirect based on logged in or not
  get '/home', to: 'videos#index'    # homepage for logged in users
      
  resources :videos, only: [:create, :new, :show] do
    post 'search', on: :collection
    resources :reviews, only: [:create]
  end
  resources :categories, only: [:create, :new, :show]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/register', to: 'users#new'
  resources :users, only: [:show, :create, :edit, :update]

end