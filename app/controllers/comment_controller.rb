class CommentController < ApplicationController
  respond_to :xml, :json

	def delete
    comment = Comment.find(params[:id])
    if comment.destroy
      respond_to do |format|
        format.html { redirect_to :back }
        format.json { head :no_content }
        format.js #added
      end
    end
	end


  def new
    comment = Comment.new
    comment.body = params[:body]
    comment.post_id = params[:post_id]
    comment.user_id = current_user[:id]
    comment.save

    # Notificaciones para el propietario del post donde se hace el COMENTARIO
    post = Post.find(params[:post_id])
		user = User.find(post.user_id)
		if user.id != comment.user_id
      note = Notifications.new
      note.user_id = user.id
      note.note_type = 1
      note.from = comment.user_id
      note.post_id = comment.post_id
      note.save
   end


	  comm = post.comments.uniq_by {|x| x.user_id}
	  comm.each do |c|
	if current_user.id != c.user_id
      note = Notifications.new
      note.user_id = c.user_id
      note.note_type = 1
      note.from = comment.user_id
      note.post_id = comment.post_id
      note.save
		end
   end

  end
end

