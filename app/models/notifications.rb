class Notifications
  #attr_accessible :user_id, :type, :form, :to, :unread
  include Mongoid::Document
    field :user_id, :type => Integer
    field :note_type, :type => Integer
    field :from, :type => Integer
    field :resource_id, :type => Integer
    field :unread, :type => Integer
end
