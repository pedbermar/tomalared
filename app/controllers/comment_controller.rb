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
      post = Post.find(@comment.post_id)
      # Notificacion para el dueño del post
      if current_user[:id] != post.user_id 
        note = Notifications.new
        note.user_id =  post.user_id
        note.note_type = Notifications::COMMENT
        note.from = current_user[:id]
        note.resource_id = @comment.post_id
        note.unread = 1
        note.save
      end
      # Notificacion para los propietarios de los comentarios del post  
      comms = post.comments.uniq_by {|x| x.user_id}
      comms.each do |c|
        if current_user[:id] != c.user_id
          note = Notifications.new
          note.user_id =  c.user_id
          note.note_type = Notifications::COMMENT
          note.from = current_user[:id]
          note.resource_id = c.post_id
          note.unread = 1
          note.save
        end
      end  
      # Notificaciones para las menciones
      mentions = Array.new
      @comment.body.split.each do |t|
        if t.first == '@'
          mentions << t.gsub(/^@/,"")
        end
      end
      mentions.each do |u|
        user = User.find_by_name(u)
        note = Notifications.new
        note.user_id = user.id
        note.note_type = Notifications::COMMENT
        note.from = current_user[:id]
        note.resource_id = @comment.id
        note.unread = 1
        note.save
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

