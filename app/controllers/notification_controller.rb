class NotificationController < ApplicationController
  def list 
    @numNotifType1 = '#{Notifications.find(:all, :conditions => {:user_id => current_user[:id], :note_type => 1, :unread => 1}).count}C'
    @numNotifType2 = '#{Notifications.find(:all, :conditions => {:user_id => current_user[:id], :note_type => 2, :unread => 1}).count}#'
    @numNotifType3 = '#{Notifications.find(:all, :conditions => {:user_id => current_user[:id], :note_type => 3, :unread => 1}).count}@'
    if params[:remote]
        respond_to do |format|
          format.html
          format.js
        end
    end
  end
end

