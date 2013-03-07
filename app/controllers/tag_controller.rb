class TagController < ApplicationController

  helper :post
  # the big man
  def is_admin_user?
    (logged_in? && current_user[:id] == User::ADMIN_USER_ID)
  end

  #
  # tag management
  #

  # ajaxly rename the tag
  def rename_tag
    if request.post?
      tag = Tag.find(params[:tag_id])
      tag.name = params[:tag_name]
      tag.save
      render :text => tag.name
    end
  end

  # up and delete a tag
  def delete_tag
    tag = Tag.find(params[:id])
    tag.destroy
    flash[:notice] = 'Tag deleted.'
    redirect_to :action => :list, :id => 'tag'
  end

  def follow_tag
    @tag = Tag.find(params[:id])
    Subscriptions.subscribe(current_user[:id], Subscriptions::S_TAG, @tag.id)
    @tag.users << User.find(current_user[:id])
    
    #foto aleatoria de la cabezera de list por tags
    @tag_foto = Post.find(:all, :joins => 'JOIN posts_tags pt ON pt.post_id = posts.id',
                          :conditions => ['pt.tag_id = tags.id AND tags.id = ? AND posts.post_type = ?', @tag, "image"],
                          :order => 'rand()',
                          :limit => 1,
                          :include => [:tags, :user])

    @tag_foto.each do |tag_foto|
      @foto_tag = tag_foto.content
    end
    @users_tag =  Tag.find(@tag).users
    respond_to do |format|
      format.js
    end
  end

  def unfollow_tag
    @tag = Tag.find(params[:id])
    current_user.tags.delete(@tag)
    #foto aleatoria de la cabezera de list por tags
    @tag_foto = Post.find(:all, :joins => 'JOIN posts_tags pt ON pt.post_id = posts.id',
                          :conditions => ['pt.tag_id = tags.id AND tags.id = ? AND posts.post_type = ?', @tag, "image"],
                          :order => 'rand()',
                          :limit => 1,
                          :include => [:tags, :user])

    @tag_foto.each do |tag_foto|
      @foto_tag = tag_foto.content
    end
    @users_tag =  Tag.find_by_sql(['SELECT u.*, tu.tag_id FROM tags_users as tu, users as u WHERE u.id = tu.user_id and tu.tag_id = ?', @tag])

    respond_to do |format|
      format.js
    end

  end
  
  def list
    if params[:id]
      @arr = Tag.find(:all, 
                         :conditions => {:id => params[:id]}, 
                         :order => 'id ASC')
    else
      @arr = Tag.find(:all, :order => 'id ASC')
    end
    if params[:json]
      list = @arr.map {| o | Hash[ name: o.name ]}
      render json: list
    end
  end
end

