class StockProductDestination < ApplicationRecord
  belongs_to :stock_product
  has_one :product_model
end
