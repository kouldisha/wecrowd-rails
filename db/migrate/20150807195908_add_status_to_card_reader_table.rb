class AddStatusToCardReaderTable < ActiveRecord::Migration
  def change
    add_column :cardreaders, :status, :string
  end
end
