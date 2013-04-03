class ShareController < ApplicationController

	def share
	  
	  share = Share.find(:first, :conditions => { :user_id => current_user[:id] , :post_id => params[:post_id]}, :limit => '1')
    if !share
      share = Share.new
      share.post_id = params[:post_id]
      share.user_id = current_user[:id]   
      share.save
    else
      share.destroy  
    end
     
  	if params[:remote]
  	  @sharePost = params[:post_id]
  		respond_to do |format|
          format.html { redirect_to :back }
          format.js
      end
    end
    	
	end
end
