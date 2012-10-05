class ExternalController < ApplicationController

	
	layout "external"   # admin layout
	helper :tumble

	def share
	   if current_user
		    @po = Post.new
		 else
		        redirect_to :controller => 'user_sessions', :action => 'new'
		 end
	end

	def index
	end

end
