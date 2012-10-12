class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.string :user_id
      t.string :post_id

      t.timestamps
    end
  end
end
