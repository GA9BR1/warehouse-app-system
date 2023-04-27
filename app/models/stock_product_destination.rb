class StockProductDestination < ApplicationRecord
  belongs_to :stock_product
  has_one :product_model
  validates :recipient, :stock_product_id, :address, presence: true
end
