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
      ActiveSupport::Notifications.instrument("p_" + "#{@comment.post_id}",
                      :note_type => Notifications::COMMENT,
                      :from => current_user[:id],
                      :resource_id => @comment.id)
      unless Subscriptions.find(:user_id => current_user[:id], :resource_type => Notifications::POST, :resource_id => @comment.post_id)
        events = []
        subscription = Subscriptions.new
        subscription.user_id = current_user[:id]
        subscription.subscriptions_type = Subscriptions::S_POST
        subscription.resource_id = @comment.post_id
        subscription.name = ActiveSupport::Notifications.subscribe ("p_" + "#{@comment.post_id}") do |*args|
          events << ActiveSupport::Notifications::Event.new(*args)
          event = events.last
          note = Notifications.new
          note.user_id = current_user[:id]
          note.note_type = event.payload[:note_type]
          note.from = event.payload[:from]
          note.resource_id = event.payload[:resource_id]
          note.unread = 1
          note.save
        end
        subscription.save
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

