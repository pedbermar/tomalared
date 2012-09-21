class Share < ActiveRecord::Base
  attr_accessible :post_id, :user_id
	validates_uniqueness_of :post_id, :scope => :user_id
end
