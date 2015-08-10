class CardreaderTable < ActiveRecord::Migration
  def change
    create_table :cardreaders do |t|
      t.integer :user_id
      t.string :name
      t.string :email
      t.integer :model_id
      t.integer :quantity
      t.string :shipping_method
    end
  end
end
