class Interaction < ActiveRecord::Base
  	attr_accessible :id, :post_id, :user_id, :int_type, :created_at, :updated_at
	
	belongs_to :post
	belongs_to :user
end