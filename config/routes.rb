Fra::Application.routes.draw do

  # a convenience route
  #resources :sessions, :constraints => { :protocol => "https" }

	#Rutas principales
  root :to 	     => "post#list"
  match "/user" => 'user_sessions#new', :as => :login

	#Login
  match '/login'      => "user_sessions#new", :as => :login
  match '/logout'     => 'user_sessions#destroy'
  match '/signup'     => 'users#new', :as => :signup

  #Usuario
  match '/home'         => 'users#edit'
  match '/edit_me'    => 'users#edit'
  match '/updatefoto' => 'users#updatefoto'
  match '/updatedatos'=> 'users#updatedatos'
  match '/updateImage'=> 'users#updateImage'
  match '/update' => 'users#update'
  match '/delete_user' => 'users#delete_user'
  match '/crop' => 'users#crop'

	#Grupos
  #Listados
	#Funciones
	match '/follow/:id' => 'tag#follow_tag'
	match '/unfollow/:id' => 'tag#unfollow_tag'

  #Tumblr
  #Listados por post
  match '/post/:pagina/:id'   => 'post#list'
  match '/post/:pagina'     => 'post#list'
  match '/network/note/:note_type'   => 'post#note'

  #Funciones
  match '/save'  => 'post#save'  
  match '/delete'     => 'post#delete'
  match '/delete_tag' => 'post#delete_tag'
  match '/post/save' => 'post#save'
  
			#Listados por usuario
			#comentarios
  match '/comment/new' => 'comment#new'
  match '/comment/delete/:id' => 'comment#delete'
  match '/comment/list/:id' => 'comment#list'

	#Likes
  match '/vote' => 'vote#vote'

  match 'activate(/:activation_code)' => 'users#activate', :as => :activate_account
  match 'send_activation(/:user_id)' => 'users#send_activation', :as => :send_activation

	#Share
  match '/share/:post_id' => 'share#share'
  match '/unshare/:post_id' => 'share#unshare'

  #Interaction
  match '/interaction/share/:post_id' => 'interaction#share'
  
  match '/notifications' => 'notification#list'
  match '/notif/index/:note_type' => 'notification#index'
  match '/notif/list' => 'notification#list'
  match '/notif/read/:note_type' => 'notification#read'

	#Buscador
  match '/search' => 'search#search'
  match '/search/searched' => 'search#searched'
  

  #External
  match 'external/activador'       => 'external#index'
  match 'external'       => 'external#share'
  match 'external/login'       => 'external#login'

	#Futuras ampliaciones
  match 'chat'       => 'chat#index'
  match 'maps'       => 'maps#index'

  match 'password_resets'=> 'password_resets#new'
  match 'password_resets/edit'=> 'password_resets#edit'
  match 'password_resets/create'=> 'password_resets#create'
  
  match '/users/crop/' => 'users#crop'
  
  match '/desde' => 'application#calcular_fecha'
  
  #resources
  resources :tags
  resources :comments
  resources :likes
  resources :users                  # give us our some normal resource routes for users
  resource :user, :as => 'account'
  resources :user_sessions
  resource :password_resets, :only => [ :new, :create, :edit, :update ]
  resources :photos, :member => {:crop => :get}
end

