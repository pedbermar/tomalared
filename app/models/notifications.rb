class Notifications
  #attr_accessible :user_id, :type, :form, :to, :unread
  
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
    field :user_id, :type => Integer
    field :note_type, :type => Integer
    field :from, :type => Integer
    field :resource_id, :type => Integer
    field :unread, :type => Integer
      
  def self.send(to, from, type, resource_id)
    unless to == from
      @note = Notifications.new
      @note.user_id = to
      @note.note_type = type
      @note.from = from
      @note.resource_id = resource_id
      @note.unread = 1
      @note.save
      @notifications = Array.new
      @notifications << @note
      PrivatePub.publish_to "/u/#{to}", { :type => "NOTIF", :note => @note }
    end
  end
end

