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
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to :action => :share
    else
      render :action => :login
    end
  end

end
