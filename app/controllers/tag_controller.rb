class TagController < ApplicationController


  helper :tumble

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
    redirect_to :action => :list_tags
  end

  def follow_tag
    @tag = Tag.find(params[:id])
    @tag.users << User.find(current_user[:id])
    redirect_to :back
  end

  def unfollow_tag
    @tag = Tag.find(params[:id])
    current_user.tags.delete(@tag)
    redirect_to :back
  end
end

