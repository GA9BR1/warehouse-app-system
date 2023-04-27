class RemoveQuantityFromStockProductDestination < ActiveRecord::Migration[7.0]
  def change
    remove_column :stock_product_destinations, :quantity, :integer
  end
end
