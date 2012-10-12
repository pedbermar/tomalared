class ExternalController < ApplicationController

	
	layout "external"   # admin layout
	helper :post

	def share
	   @post = Post.new(params[:post])
	   if current_user
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
        direcion2 = "http://0.0.0.0:3000/post/#{capturanombre}.jpg"
        @post.content = direcion2
      end
      
      if @post.post_type == 'link'
        require 'metainspector'
        require 'iconv'
        @url_link = @post.content
        doc = MetaInspector.new(@post.content)
        desc = doc.description
        @post.title = doc.title
        if doc.image
          require 'open-uri'
          capturanombre = "#{post.user_id}-#{Time.now.to_a.join}"
          direcion = "public/post/#{capturanombre}.jpg"
          open(direcion, "wb") do |file|
            file << open(doc.image).read
          end
          img_url = "http://0.0.0.0:3000/post/#{capturanombre}.jpg"
          @post.content = desc + "\n" + img_url + "\n" + doc.url
        else
          @post.content = desc + "\n" + "no-img" + "\n" + doc.url
        end        
      end
      
		 else
		    redirect_to  :action => 'login', :title => @post.title, :content => @post.content, :post_type => @post.post_type
		 end
	end

	def index
	end
	
	def login
	  @post = Post.new(params[:post])
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to :action => :share, 'post[title]' => @post.title, 'post[content]' => @post.content, 'post[post_type]' => @post.post_type
    end
  end

end
