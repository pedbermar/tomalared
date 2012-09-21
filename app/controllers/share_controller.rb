class ShareController < ApplicationController

	def share
		share = Share.new
		share.post_id	= params[:post_id]
		share.user_id = current_user[:id]		
		share.save
		redirect_to :back
	end

	def unshare
		share = Share.find(:first, :conditions => { :user_id => current_user[:id] , :post_id => params[:post_id]}, :limit => '1')
		share.destroy
		redirect_to :back
	end
end
