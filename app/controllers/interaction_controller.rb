class InteractionController < ApplicationController

	def share
    interaction = current_user.interactions.where(:post_id => params[:post_id], :int_type => Interaction::I_SHARE).limit(1)
    if !interaction
      interaction = Interaction.new
      interaction.post_id = params[:post_id]
      interaction.user_id = current_user[:id]
      interaction.int_type = Interaction::I_SHARE
      interaction.save
    else
      Interaction.destroy(interaction.id)
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