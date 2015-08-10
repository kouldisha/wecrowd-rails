class ChangeorderIdColumnName < ActiveRecord::Migration
  def change
    rename_column :cardreaders, :order_ID, :order_id
  end
end
