Rails.application.routes.draw do
	root   'static_pages#home'
  get 	 '/signup', 	 to: 'users#new'
  post 	 '/signup',  	 to: 'users#create'
  get  	 '/help',    	 to: 'static_pages#help'
  get  	 '/about',     to: 'static_pages#about'
  get  	 '/contact',   to: 'static_pages#contact'
  get 	 '/login', 		 to: 'sessions#new'
  post 	 '/login', 		 to: 'sessions#create'
  delete '/logout',    to: 'sessions#destroy'
  resources :users do
    member do
      # GET /users/1/following  following following_user_path(1)
      # GET /users/1/followers  followers followers_user_path(1)
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end