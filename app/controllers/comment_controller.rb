# encoding: utf-8

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
      require 'htmlentities'
      coder = HTMLEntities.new
      string = @comment.body
      @comment.body = coder.encode(string, :basic)
        
      # Agregar tags
      t11 = Array.new
      @comment.body.split.each do |t|
        if t.first == '#'
          t = t.gsub(/^#/,"")
          t = t.gsub(/[áäà]/i, "a")
          t = t.gsub(/[éëè]/i, "e")
          t = t.gsub(/[íïì]/i, "i")
          t = t.gsub(/[óöò]/i, "o")
          t = t.gsub(/[úüù]/i, "u")
          t = t.gsub(/[^a-zA-Z0-9ñÑçÇ\']/i, "")
          t11 << t
        end
      end

      t11.each do |t|
        tag = Tag.find_by_name(t) || Tag.new(:name => t)
        @comment.post.tags << tag
        subs = Subscriptions.where(:post_id => tag.id, :resource_type => Subscriptions::S_TAG)
        subs.each do |sub|
          Notification.send_notification(sub.user_id, current_user[:id], Notification::TAG_POST, @comment.post_id)
        end
      end
      
     # Notificaciones para los subscriptores del post  
      sub = Subscriptions.where(:resource_id => @comment.post_id, :resource_type => Subscriptions::S_POST)
      sub.each do |s|
          Notification.send_notification(s.user_id, current_user[:id], Notification::COMMENT, s.resource_id, @comment.id)
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
        Notification.send_notification(user.id, current_user[:id], Notification::USER, @comment.post_id, @comment.id)
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
  
  def list
    @comment = Comment.find(params[:id])
    respond_to do |format|
      format.js
    end
  end
end

