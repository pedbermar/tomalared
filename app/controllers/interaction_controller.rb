class InteractionController < ApplicationController

	def share
    interactions = current_user.interactions.where(:post_id => params[:post_id], :int_type => Interaction::I_SHARE)
    if interactions.count == 0
      interaction = Interaction.new
      interaction.post_id = params[:post_id]
      interaction.user_id = current_user[:id]
      interaction.int_type = Interaction::I_SHARE
      interaction.save
      post = Post.find(params[:post_id])
      if post
        Notification.send_notification(post.user_id, current_user[:id], Notification::SHARE, post.id, interaction.id)
      end
    else
      interactions.each do |i|
        i.destroy
      end
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