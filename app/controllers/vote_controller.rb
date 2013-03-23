class VoteController < ApplicationController
  def vote
    like = Like.find(:first, :conditions => {:user_id => current_user[:id], :like_type => params[:like_type], :type_id => params[:type_id]})
    if !like
      like = Like.new
    end 
    like.user_id = current_user[:id]
    like.like_type = params[:like_type]
    like.type_id = params[:type_id]
    if params[:dontLike]
      like.dontlike = 1
      like.like = 0
    end
    if params[:like]
      like.dontlike = 0
      like.like = 1
    end
    like.save
    if params[:like_type] == 1
      @post = true
    end
    if params[:like_type] == 2
      @comment = true
    end
    @numLikes = Like.find(:all, :conditions => {:like_type => params[:like_type], :type_id => params[:type_id], :like => 1, :dontlike => 0 }).count - Like.find(:all, :conditions => {:like_type => params[:like_type], :type_id => params[:type_id], :like => 0, :dontlike => 1 }).count
    if params[:remote]
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    end
  end
end
