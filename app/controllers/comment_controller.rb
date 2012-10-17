class CommentController < ApplicationController
  respond_to :xml, :json
  def delete
    @comment = Comment.find(params[:id])
    if @comment
      if @comment.destroy
        flash[:notice] = 'El mensaje se ha borrado correctamente.'
      else
        flash[:notice] = 'Ha habido un problema al borrar el mensaje.'
      end
    else
      flash[:notice] = 'No se encuentra el mensaje.'
    end
    respond_to do |format|
      format.html { redirect_to }
      format.json { head :no_content }
      format.js #added
    end
  end

  def new
    @comment = Comment.create!(:body => params[:body], :post_id => params[:post_id], :user_id => current_user[:id])
    
    if @comment
      # Notificaciones para el propietario del post donde se hace el COMENTARIO
      post = Post.find(params[:post_id])
      user = User.find(post.user_id)
      if user.id != @comment.user_id
        note = Notifications.new
        note.user_id = user.id
        note.note_type = 1
        note.from = @comment.user_id
        note.post_id = @comment.post_id
        note.save
      end

      comm = post.comments.uniq_by {|x| x.user_id}
      comm.each do |c|
        if current_user.id != c.user_id
          note = Notifications.new
          note.user_id = c.user_id
          note.note_type = 1
          note.from = @comment.user_id
          note.post_id = @comment.post_id
          note.save
        end
      end
      flash[:notice] = 'El mensaje se ha guardado correctamente.'
    else
      flash[:notice] = 'Hubo un problema al guardar el mensaje.'
    end
    respond_to do |format|
      format.html { redirect_to }
      format.json { head :no_content }
      format.js #added
    end
  end
end

