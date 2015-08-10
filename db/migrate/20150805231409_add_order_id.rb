class AddOrderId < ActiveRecord::Migration
  def change
    add_column :cardreaders, :order_ID, :integer
  end
end
