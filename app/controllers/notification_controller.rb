class NotificationController < ApplicationController
  def list 
    @po = Post.new
    if params[:id]
      @notifications = Notifications.where(:resource_id => params[:id])
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
    @notifications = Notifications.where(:user_id => current_user[:id]).asc(:created_at).reverse[0..20]
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
end

