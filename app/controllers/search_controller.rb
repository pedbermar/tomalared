class SearchController < ApplicationController

 def search
	if params[:q] != ""

      @q = params[:q]
      @q1 = params[:q]
      
			if @q.scan(/^#/){$1} 
				@q = @q.gsub(/^#/,"")
			end
		  if @q.scan(/^@/){$1}
        @q = @q.gsub(/^@/,"")            
      end

	    @tags = Tag.search(@q).sort { |x, y| x.name <=> y.name }[0..11]
	    @users = User.search(@q).sort { |x, y| x.name <=> y.name }[0..11]
	    @posts = Post.search(@q1).sort_by{ |p| - p.id}[0..3]
	else
		redirect_to :back
  end

 end

end
