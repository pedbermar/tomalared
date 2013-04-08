class Notification
  
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
    field :user_id, :type => Integer
    field :note_type, :type => Integer
    field :from_id, :type => Integer
    field :post_id, :type => Integer
    field :resource_id, :type => Integer
    field :unread, :type => Integer
  
  include Tenacity  
    t_belongs_to :post
    t_belongs_to :resource, :class_name => "Comment"
    t_belongs_to :user
    t_belongs_to :from, :class_name => "User", :foreign_key => 'from_id'
    
    def self.send_notification(to, from, type, post_id, resource_id = nil) 
        unless to == from
          @note = Notification.new
          @note.user_id = to
          @note.note_type = type
          @note.from_id = from
          @note.post_id = post_id
          @note.resource_id = resource_id
          @note.unread = 1
          @note.save
          
          @notifications = Array.new
          @notifications << @note
          PrivatePub.publish_to "/u/#{to}", { :note => @note, :type => "NOTIF" }
        end
     end
end

     
  