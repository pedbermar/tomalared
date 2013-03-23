class Subscriptions
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
    field :user_id, :type => Integer
    field :resource_type, :type => Integer
    field :resource_id, :type => Integer


  def self.subscribe(user_id, resource_type, resource_id)
    sub = self.new
    sub.user_id = user_id
    sub.resource_type = resource_type
    sub.resource_id = resource_id
    sub.save
  end 
  
  def self.unsubscribe(subscription_id)
    sub = self.where(:resource_id => resurce_id)
    sub.delete
  end
end