class RenameWarenhouseToWarehouse < ActiveRecord::Migration[7.0]
  def change
    rename_table :warenhouses, :warehouses
  end
end
