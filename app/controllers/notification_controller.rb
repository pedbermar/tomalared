class NotificationController < ApplicationController
  def list 
    @numNotifUser = Notifications.find(:all, :conditions => {:user_id => current_user[:id], :note_type => 1, :unread => 1}).count
    @numNotifFollow = Notifications.find(:all, :conditions => {:user_id => current_user[:id], :note_type => 2, :unread => 1}).count
    @numNotifTagPost = Notifications.find(:all, :conditions => {:user_id => current_user[:id], :note_type => 3, :unread => 1}).count
    @numNotifComment = Notifications.find(:all, :conditions => {:user_id => current_user[:id], :note_type => 5, :unread => 1}).count
    if params[:remote]
        respond_to do |format|
          format.html
          format.js
        end
    end
  end
end

