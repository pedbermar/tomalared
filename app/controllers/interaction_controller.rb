class InteractionController < ApplicationController

	def share
	  
	  interaction = current_user.interactions.where(:post_id => params[:post_id], :type => Interactions::SHARE)
    if !interaction
      interaction = Interaction.new
      interaction.post_id = params[:post_id]
      interaction.user_id = current_user[:id]
      interaction.type = current_user[:id]
      interaction.save
    else
      interaction.destroy  
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