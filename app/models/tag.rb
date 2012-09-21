class Tag < ActiveRecord::Base

  belongs_to :post
  has_and_belongs_to_many :users

  attr_accessible :name
# get rid of any tags that aren't attached to a post
  def self.prune_tags
    find(:all, :include => [:posts]).each { |t| t.destroy if t.posts.size == 0 }
  end

  def self.find_most_popular(limit)
    find_by_sql("SELECT t.*, count(1) count FROM posts_tags pt
                 JOIN tags t ON t.id = pt.tag_id GROUP BY tag_id
                 ORDER BY count DESC LIMIT #{limit}")
  end

  def self.find_most_popular_by_user(user)
    find_by_sql("SELECT t. * , COUNT( 1 ) count
									FROM posts_tags pt
									JOIN tags t ON ( t.id = pt.tag_id ) 
									JOIN posts p ON ( p.id = pt.post_id ) 
									WHERE p.user_id = #{user}
									GROUP BY tag_id
									ORDER BY count DESC")
  end

	def self.search(query)
		  if query
		      tokens = query.split.collect {|c| "%#{c.downcase}%"} 
		      r = find_by_sql(["SELECT * from tags WHERE #{ (["LOWER(name) like ?"] * tokens.size).join(" OR ") }", *tokens])
		      return r.uniq # No need for duplicate entries
		  end
	end

end

