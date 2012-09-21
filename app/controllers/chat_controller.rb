
class ChatController < ApplicationController
 def index
    @messages = Chat.all
  end
  
  def create
    @message = Chat.create!(params[:message])
  end
	
end
