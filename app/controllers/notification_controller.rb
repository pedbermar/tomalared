class NotificationController < ApplicationController
  def list 
    @po = Post.new
    @notifications = Notifications.where(:user_id => current_user[:id]).asc(:created_at).reverse[0..20]
    if params[:remote]
        respond_to do |format|
          format.html
          format.js
        end
    end
  end
end

