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

	    @tags = Tag.search(@q).sort { |x, y| x.name <=> y.name }
	    @users = User.search(@q).sort { |x, y| x.name <=> y.name }
	    @posts = Post.search(@q1).sort_by{ |p| - p.id}
	else
		redirect_to :back
  end

 end
 
 
  def searched
    
    if params[:term]
      @q = params[:term]
      tags = Array.new
      users = Array.new      
            
      if @q[0] == "#" 
        @q1 = @q.gsub(/^#/,"")
        like= "%".concat(@q1.concat("%"))
        tags = Tag.where("name like ?", like)
      elsif @q[0] == "@"
        @q1 = @q.gsub(/^@/,"")
        like= "%".concat(@q1.concat("%"))
        users = User.where("name like ?", like)        
      else 
        like= "%".concat(@q.concat("%"))
        users = User.where("name like ?", like)
        tags = Tag.where("name like ?", like)
      end
      
    list = users.map {|u| Hash[ id: u.id, label: "@#{u.name}", name: u.name, tipo: "user", img: "/img/#{u.id}.jpg" ]}
    list = list + tags.map {|t| Hash[ id: t.id, label: "##{t.name}", name: t.name, tipo: "tag", img: "/img/tag.png" ]}  
    list = list.sort_by {|a,b| a[:name]}
    render json: list
    end
  end
end