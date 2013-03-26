class CreateInteractions < ActiveRecord::Migration
  def self.up
    create_table :interactions do |t|
      t.integer :user_id
      t.integer :post_id
      t.integer :type, :default => 0, :null => 0

      t.timestamps
    end
  end
  def self.down
    drop_table :interactions
  end
end
