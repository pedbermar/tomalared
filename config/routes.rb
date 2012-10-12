Fra::Application.routes.draw do

  # a convenience route
  #resources :sessions, :constraints => { :protocol => "https" }

	#Rutas principales
  root :to 	     => 'user_sessions#new', :as => :login

	#Login
  match '/login'      => "user_sessions#new", :as => :login
  match '/logout'     => 'user_sessions#destroy'
  match '/signup'     => 'users#new', :as => :signup

	#Usuario
  match '/home'         => 'users#show'
  match '/edit_me'    => 'users#edit'
  match '/updatefoto' => 'users#updatefoto'
  match '/updatedatos'=> 'users#updatedatos'
  match '/update' => 'users#update'

	#Grupos
			#Listados
  match '/group/:tag' => 'post#list_tag'
  match '/group/:id'  => 'post#list_tag'
			#Funciones
	match '/follow/:id' => 'tag#follow_tag'
	match '/unfollow/:id' => 'tag#unfollow_tag'

	#Tumblr
			#Listados por post
  match '/post/:id'   => 'post#list'
  match '/network/note/:note_type'   => 'post#note'
  match '/network'     => 'post#list'
			#Funciones
  match '/save'  => 'post#save'
  match '/edit'  => 'post#edit'
  match '/delete'     => 'post#delete'
  match '/delete_tag' => 'post#delete_tag'
  match '/post/save' => 'post#save'
  match '/post/mentions' => 'post#mentions'
			#Listados por usuario
  match '/me'  => 'post#list_user'
  match '/profile/:name'       => 'post#list_user'
			#comentarios
  match '/comment/new' => 'comment#new'
  match '/comment/delete/:id' => 'comment#delete'

	#Likes
  match '/like' => 'vote#like'
  match '/dontlike' => 'vote#dontlike'
  match '/change_to_like' => 'vote#change_to_like'
  match '/change_to_dontlike' => 'vote#change_to_dontlike'

  match 'activate(/:activation_code)' => 'users#activate', :as => :activate_account
  match 'send_activation(/:user_id)' => 'users#send_activation', :as => :send_activation

	#Share
  match '/share/:post_id' => 'share#share'
  match '/unshare/:post_id' => 'share#unshare'

	#Buscador
  match '/search' => 'search#search'

  #External
  match 'external/activador'       => 'external#index'
  match 'external'       => 'external#share'
  match 'external/login'       => 'external#login'

	#Futuras ampliaciones
  match 'chat'       => 'chat#index'
  match 'maps'       => 'maps#index'

  match 'password_resets'=> 'password_resets#new', :only => [ :new, :create, :edit, :update ]

  #resources
  resources :tags
  resources :comments
  resources :likes
  resources :users                  # give us our some normal resource routes for users
  resource :user, :as => 'account'
  resources :user_sessions
  resource :password_resets, :only => [ :new, :create, :edit, :update ]

end

