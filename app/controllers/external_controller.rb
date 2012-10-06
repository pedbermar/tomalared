class ExternalController < ApplicationController

	
	layout "external"   # admin layout
	helper :tumble

	def share
	   if current_user
		    @post = Post.new(params[:post])
		    
		    if @post.post_type == 'image'
        capturanombre = "#{@post.user_id}-#{Time.now}"
        capturanombre = capturanombre.gsub(" ","")
        direcion = "public/post/#{capturanombre}.jpg"
        if params[:img] == nil
          require 'open-uri'
          open(direcion, "wb") do |file|
            file << open(@post.content).read
          end
        else
          File.open(direcion, "wb") do |file|
            file << open(params[:img]).read
          end
        end
        direcion2 = "/post/#{capturanombre}.jpg"
        @post.content = direcion2
      end
		 else
		    redirect_to  :action => 'login'
		 end
	end

	def index
	end
	
	def login
	  @post = Post.new(params[:post])
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to :action => :share
    else
      render :action => :login
    end
  end

end
