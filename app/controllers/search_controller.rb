class SearchController < ApplicationController

 def search
	if params[:q] != ""

			if params[:q].scan(/^#\w+/){$1} 
				@lo = params[:q].scan(/^#\w+/)
			end

	    @tags = Tag.search(params[:q])
	    @users = User.search(params[:q])
	    @posts_s = Post.search(params[:q])

	else
		redirect_to "/network"
  end

 end

end
