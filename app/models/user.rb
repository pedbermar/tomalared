#
# Inspired by the authentication example in the Pragmatic Programmers'
# Agile Web Development with Ruby on Rails.  Nothing too crazy.
#

class CantDestroyAdminUser < StandardError; end

class User < ActiveRecord::Base
  ADMIN_USER_ID = 1
  PASSWORD_MIN_LENGTH = 6

  acts_as_authentic do |c|
  end

  has_many :posts, :order => 'created_at DESC'
  has_and_belongs_to_many :tags
  has_many :comments, :order => "created_at DESC", :through => :posts
  has_many :notifications, :order => "created_at DESC", :through => :posts
  has_many :likes

  before_destroy :dont_destroy_admin

  #attr_accessor   :password
  #attr_accessible :name, :password, :email
  attr_accessible :id, :name, :email, :password, :password_confirmation, :openid_identifier, :notifications

  validates_uniqueness_of :name
  validates_presence_of   :name
  validates_presence_of   :password, :on => :create

  #has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  def before_save
    # hash the plaintext password and set it to an instance variable
    self.hashed_password = User.hash_password(self.password) if self.password
  end

  def after_save
    # get rid of the plaintext password
    @password = nil
  end

  def self.password_long_enough?(password)
    (password.length >= PASSWORD_MIN_LENGTH ? true : false)
  end

  def self.passwords_match?(password, confirm)
    (password == confirm ? true : false)
  end

  def dont_destroy_admin
    # that's you.
    raise CantDestroyAdminUser if self.id == 1
  end

  def active?
   active
  end

  def activate!
    self.active = true
    save
  end

  def deactivate!
    self.active = false
    save
  end

  def send_activation_instructions!
    reset_perishable_token!
    Notifier.activation_instructions(self).deliver
  end

  def send_activation_confirmation!
    reset_perishable_token!
    Notifier.activation_confirmation(self).deliver
  end

  def email_address_with_name
    "#{self.name} <#{self.email}>"
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.password_reset_instructions(self)
  end


#########################################
#### Buscar usarios por nombre

  def self.users_for_name(name)
      find_by_sql("SELECT * FROM users WHERE name like '%#{name}%';")
  end

  def self.users_for_id(id)
      find_by_sql("SELECT * FROM users WHERE id = '%#{id}%' limit 1;")
  end

	def self.search(query)
		  if query
		      tokens = query.split.collect {|c| "%#{c.downcase}%"}
		      r = find_by_sql(["SELECT * from users WHERE #{ (["LOWER(name) like ?"] * tokens.size).join(" OR ") }", *tokens])
		      return r.uniq # No need for duplicate entries
		  end
	end
end

