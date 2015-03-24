Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'        # redirects to front page which will redirect based on logged in or not
  get '/home', to: 'videos#index'    # homepage for logged in users
      
  resources :videos, only: [:create, :new, :show] do
    post 'search', on: :collection
    resources :reviews, only: [:create]
  end
  resources :categories, only: [:create, :new, :show]

  get '/people', to: 'followings#index'
  resources :followings, only: [:create, :destroy]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/register', to: 'users#new'
  resources :users, only: [:show, :create, :edit, :update]

  get '/queue', to: 'lines#index', as: 'show_queue'
  post '/add_2_queue', to: 'lines#create'
  delete '/queue/:id', to: 'lines#destroy', as: 'remove_queue_item'
  post '/queue/', to: 'lines#update', as: 'update_queue'

  get '/forgot_password', to: 'users#request_reset'
  post '/send_reset_link', to: 'users#send_reset_link'
  get '/reset_password/:token', to: 'users#enter_new_password', as: 'reset_link'
  post 'reset_password', to: 'users#reset_password'
end
