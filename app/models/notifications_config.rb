class NotificationsConfig
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
    field :user_id, :type => Integer
    field :user_notifications, :type => Boolean, :default => true
    field :tag_notifications, :type => Boolean, :default => true
    field :post_notifications, :type => Boolean, :default => true
end
