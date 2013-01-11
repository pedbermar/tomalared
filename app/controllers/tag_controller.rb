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
    @tag.users << User.find(current_user[:id])
    ActiveSupport::Notifications.instrument("t_" + "#{@tag .id}",
                      :note_type => Notifications::FOLLOW,
                      :from => current_user[:id],
                      :resource_id => @tag.id)
                      
    events = []
    subscription = Subscriptions.new
    subscription.user_id = current_user[:id]
    subscription.subscription_type = Subscriptions::S_TAG
    subscription.resource_id = @tag.id
    subscription.name = ActiveSupport::Notifications.subscribe ("t_" + "#{@tag.id}") do |*args|
      events << ActiveSupport::Notifications::Event.new(*args)
      event = events.last
      note = Notifications.new
      note.user_id = current_user[:id]
      note.note_type = event.payload[:note_type]
      note.from = event.payload[:from]
      note.resource_id = event.payload[:resource_id]
      note.unread = 1
      note.save
    end
    subscription.save
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

  def unfollow_tag
    @tag = Tag.find(params[:id])
    sub = Subscriptions.where(user_id: "#{current_user[:id]}", subscription_type: Subscriptions::S_TAG, resource_id: "#{@tag.id}")
    ActiveSupport::Notifications.unsubscribe(sub.name)
    sub.destroy
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
end

