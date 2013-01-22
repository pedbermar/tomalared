class Notifications_config
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
    field :user_id, :type => Integer
    field :user_notifications, :type => Integer
    field :tag_notifications, :type => Integer
    field :post_notifications, :type => Integer
end
