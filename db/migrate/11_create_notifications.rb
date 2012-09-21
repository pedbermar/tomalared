class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :note_type
      t.integer :from
      t.integer :post_id
      t.boolean :unread, :default => true, :null => false
      t.timestamps
    end
  end
end

