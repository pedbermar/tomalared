class GoreUpdates < ActiveRecord::Migration
  def change
    create_table :tags_users, :id => false do |t|
      t.integer :user_id
      t.integer :tag_id
    end
    add_index :tags_users, [:user_id, :tag_id]
  end
end

