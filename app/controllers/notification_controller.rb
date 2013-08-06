class NotificationController < ApplicationController
  def list 
    @po = Post.new
    if params[:id]
      @notifications = Notification.where(:post_id => params[:id])
    else
      @notifications = Notifications.where(:user_id => current_user[:id]).asc(:created_at).reverse[0..20]
    end
    if params[:remote]
        respond_to do |format|
          format.js
        end
    end
  end
  
  def index
    @notifications = Notification.where(:user_id => current_user[:id], :note_type => params[:note_type] ).asc(:created_at).reverse[0..20]
    respond_to do |format|
      format.js
    end
  end
  
  def update_config
    @config = NotificationsConfig.where(:user_id => current_user[:id])
    if @config.update_attributes(params[:config])
      @config.save
      flash[:notice] = "Tu cuenta ha sido actualizada!"
    end
  end
  
  def read
    notifications = Notification.where(:user_id => current_user[:id], :note_type => params[:note_type])
    @numNotif = notifications.count
    notifications.each do |n|
      n.unread = 0
      n.save
    end
    respond_to do |format|
      format.js
    end
  end
end

