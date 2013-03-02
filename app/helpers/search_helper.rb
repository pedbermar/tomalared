module SearchHelper
  def tag_photo (tag)
      @tag_foto = Post.find(:all, 
                              :joins => "JOIN posts_tags pt ON pt.post_id = posts.id",
                              :conditions => ["pt.tag_id = tags.id AND tags.name = ? AND posts.post_type = ?", tag, "image"],
                              :order => "rand()",
                              :limit => 1,
                              :include => [:tags, :user])
      if @tag_foto.first                     
        return @tag_foto.first.content
      end
  end
end
