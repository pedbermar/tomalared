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
     # Notificaciones para los subscriptores del post  
      sub = Subscriptions.where(:resource_id => @comment.post_id, :resource_type => Subscriptions::S_POST)
      sub.each do |s|
          Notifications.send(s.user_id, current_user[:id], Notifications::COMMENT, s.resource_id)
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
        Notifications.send(user.id, current_user[:id], Notifications::USER, @comment.id)
      end
      # Nos subscribimos al post
      unless Subscriptions.where(:user_id => current_user[:id], :resource_type => Subscriptions::S_POST, :resource_id => @comment.post_id).exists?
        Subscriptions.subscribe(current_user[:id], Subscriptions::S_POST, @comment.post_id)
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

