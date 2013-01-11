class Subscriptions
  include Mongoid::Document
    field :name, :type => String
    field :user_id, :type => Integer
    field :subscription_type, :type => Integer
    field :resource_id, :type => Integer
end
