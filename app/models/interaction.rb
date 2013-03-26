class Interaction < ActiveRecord::Base
  	attr_accessible :post_id, :user_id, :type, :created_at, :updated_at
	
	belongs_to :posts, :dependent => :destroy
	belongs_to :users
end