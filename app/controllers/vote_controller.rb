class VoteController < ApplicationController
		#Likes
	def like
		like = Likes.new
		like.user_id = current_user[:id]
		like.like_type = params[:like_type]
		like.type_id = params[:type_id]
		like.dontlike = 0
		like.like = 1
		like.save
		redirect_to :back
	end

	def dontlike
		like = Likes.new
		like.user_id = current_user[:id]
		like.like_type = params[:like_type]
		like.type_id = params[:type_id]
		like.dontlike = 1
		like.like = 0
		like.save
		redirect_to :back
	end

	def change_to_like
		like = Likes.find(:first, :conditions => {:user_id => current_user[:id], :like_type => params[:like_type], :type_id => params[:type_id]}) 
		like.dontlike = 0
		like.like = 1
		like.save
		redirect_to :back
	end

	def change_to_dontlike
		like = Likes.find(:first, :conditions => {:user_id => current_user[:id], :like_type => params[:like_type], :type_id => params[:type_id]}) 
		like.dontlike = 1
		like.like = 0
		like.save		
		redirect_to :back
	end
end
