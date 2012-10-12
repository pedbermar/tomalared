class GetYourTumbleOn < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.column :user_id,    :int
      t.column :title,      :string
      t.column :post_type,  :string
      t.column :content,    :text
      t.column :created_at, :datetime
    end
    add_index :posts, :id, :unique
    
    create_table(:posts_tags, :id => false) do |t|
      t.column :post_id, :int
      t.column :tag_id,  :int
    end
    add_index :posts_tags, [:post_id, :tag_id]
    
    create_table :tags do |t|
      t.column :name,       :string,  :limit => 25
      t.column :updated_at, :datetime
    end
    add_index :tags, :id, :unique
    
    create_table :users do |t|
      # t.string    :login,             :null => false                # optional, see below
      t.string    :crypted_password,    :null => false                # optional, see below
      t.string    :password_salt,       :null => false                # optional, but highly recommended
      t.string    :email,               :null => false                # optional, you can use login instead, or both
      t.string    :persistence_token,   :null => false                # required
      t.string    :single_access_token, :null => false                # optional, see Authlogic::Session::Params
      t.string    :perishable_token,    :null => false                # optional, see Authlogic::Session::Perishability
      
      # Magic columns, just like ActiveRecord's created_at and updated_at. 
      # These are automatically maintained by Authlogic if they are present.

      t.integer   :login_count,         :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.integer   :failed_login_count,  :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_request_at                                    # optional, see Authlogic::Session::MagicColumns
      t.datetime  :current_login_at                                   # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_login_at                                      # optional, see Authlogic::Session::MagicColumns
      t.string    :current_login_ip                                   # optional, see Authlogic::Session::MagicColumns
      t.string    :last_login_ip                                      # optional, see Authlogic::Session::MagicColumns
      
      t.string    :name,                :null => false, :default => ''
      t.timestamps
    end
    

    add_index :users, :id, :unique
    User.new( :name => "admin", :password => 'changeme', :email => 'root@tomalared.net' ).save
    
    Post.new( :title => "first post!", :post_type => "post", 
              :content => %[Hello, world.  We take the network'<br/>!
              Hola Mundo. Hemos estoy tomado la red.<br/>
              http://tomalared.net],
              :user_id => 1 ).save
  end

  def self.down
    %w[posts posts_tags tags users].each { |t| drop_table t.to_sym }
  end
end
