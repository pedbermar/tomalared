class Comment < ActiveRecord::Base
  include Tenacity
  attr_accessible :body, :post_id, :post, :user_id

  belongs_to :users
  belongs_to :post
  has_many :likes, :foreign_key => 'type_id',:conditions => ['like_type = 2'], :dependent => :destroy
  t_has_many :notifications, :foreign_key => 'resource_id', :conditions => ['resource_type = 5 '], :dependent => :destroy
  
  DB_TEXT_MAX_LENGTH= 2000

  validates_presence_of :body, :post_id, :user_id
  validates_length_of :body, :maximum => DB_TEXT_MAX_LENGTH

  # Prevent duplicate comments.
  validates_uniqueness_of :body, :scope => [:post_id, :user_id]

  # Return true for a duplicate comment (same user and body).
  def duplicate?
    c = Comment.find_by_post_id_and_user_id_and_body(post, user, body)
    # Give self the id for REST routing purposes.
    self.id = c.id unless c.nil?
    not c.nil?
  end

  # Check authorization for destroying comments.
  def authorized?(user)
    post.user == user
  end
end
