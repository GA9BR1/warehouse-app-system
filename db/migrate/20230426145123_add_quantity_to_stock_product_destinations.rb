class AddQuantityToStockProductDestinations < ActiveRecord::Migration[7.0]
  def change
    add_column :stock_product_destinations, :quantity, :integer
  end
end
