class Notification
  #attr_accessible :user_id, :type, :form, :to, :unread
  

  
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
    field :user_id, :type => Integer
    field :note_type, :type => Integer
    field :from, :type => Integer
    field :post_id, :type => Integer
    field :unread, :type => Integer


  
  include Tenacity  
    t_belongs_to :post
    
    def self.send_notification(to, from, type, post_id, comment_id = nil) 
        unless to == from
          @note = Notification.new
          @note.user_id = to
          @note.note_type = type
          @note.from = from
          @note.post_id = post_id
          @note.unread = 1
          @note.save
          
          
          @notifications = Array.new
          @notifications << @note
          PrivatePub.publish_to "/u/#{to}", { :note => @note, :comment_id => comment_id }
        end
     end
end

     
  