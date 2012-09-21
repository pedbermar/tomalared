class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :like_type
      t.integer :type_id
      t.boolean :like
      t.boolean :dontlike

      t.timestamps
    end
  end
end
