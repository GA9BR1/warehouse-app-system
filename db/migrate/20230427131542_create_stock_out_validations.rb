class CreateStockOutValidations < ActiveRecord::Migration[7.0]
  def change
    create_table :stock_out_validations do |t|
      t.references :product_model, null: false, foreign_key: true
      t.integer :quantity
      t.string :recipient
      t.string :address

      t.timestamps
    end
  end
end
