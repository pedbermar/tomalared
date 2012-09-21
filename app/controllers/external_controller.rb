class ExternalController < ApplicationController

	#uses_yui_editor
	layout "external/layout"   # admin layout
	include Ozimodo::CookieAuth      # login stuff
	#session :disabled => false
	helper :tumble, :admin

	def share
		@po = Post.new
	end

	def index
	end

	# the big man
	def is_admin_user?
	    (logged_in? && current_user[:id] == User::ADMIN_USER_ID)
	end
	
	def login
	    	if request.post?
	      		@user = User.new(params[:user])
	      
			# login check is built into the user model
			logged_in_user = @user.try_to_login

			if logged_in_user				
				set_logged_in(logged_in_user, params[:remember_me])
				redirect_to :action => 'share'
			else
				flash[:notice] = 'Usuario o Clave incorectos.'
				render 'external/registro' 
			end
		      # user's already logged in
		      @user = User.new
	    	else	
		        flash[:notice]    = 'Tienes que logearte para aceder a los servicos. Puedes crearte un usuario'
			render 'external/registro'   
	       end 
	end
end
