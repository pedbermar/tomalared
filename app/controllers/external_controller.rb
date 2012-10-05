class ExternalController < ApplicationController

	
	layout "external"   # admin layout
	helper :tumble

	def share
	   if current_user
		    @po = Post.new
		 else
		        redirect_to  :action => 'login'
		 end
	end

	def index
	end
	
	def login
  end

end
