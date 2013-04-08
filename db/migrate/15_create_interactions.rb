class CreateInteractions < ActiveRecord::Migration
  def self.up
    create_table :interactions do |t|
      t.integer :user_id
      t.integer :post_id
      t.integer :int_type, :default => "0", :null => "0"

      t.timestamps
    end

    Interaction.new(:post_id => 1, :user_id => 1).save
  end
  def self.down
    drop_table :interactions
  end
end
