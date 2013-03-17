class User < ActiveRecord::Base

  include Tenacity
  
  acts_as_authentic do |c|
    c.login_field :name
    c.validate_email_field = false
  end
  
  has_many :posts, :order => 'created_at DESC', :dependent => :destroy
  has_and_belongs_to_many :tags
  has_many :comments, :order => "created_at DESC", :through => :posts, :dependent => :destroy
  has_many :likes, :dependent => :destroy
  has_many :shares, :dependent => :destroy
  has_many :posts
  t_has_many :notifications
  t_has_many :froms, :class_name => "Notification", :foreign_key => "from_id"
  attr_accessible :crop_x, :crop_y, :crop_w, :crop_h
  has_attached_file :photo, :styles => { :small => "50x50", :medium => "210x210", :large => "500x500"}, :processors => [:cropper]
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  
  attr_accessible :id, :profile, :name, :email,:url, :bio, :password, :password_confirmation, :openid_identifier, :notifications, :photo

  validates_uniqueness_of :name
  validates_presence_of   :name
  validates_presence_of   :profile
  validates_presence_of   :email
  validates_presence_of   :password, :on => :create

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end
  
  def avatar_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(photo.path(style))
  end
  

  
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

