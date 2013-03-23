class Like < ActiveRecord::Base
  attr_accessible :dontlike, :like, :like_type, :type_id, :user_id
  validates_uniqueness_of :user_id, :scope => [:type_id, :like_type]
	
  belongs_to :post
end
