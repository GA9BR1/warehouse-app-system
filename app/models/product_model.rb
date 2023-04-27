class ProductModel < ApplicationRecord
  belongs_to :supplier
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :stock_products
  has_many :warehouses, through: :stock_products
  validates :name, :sku, :weight, :height, :width, :supplier_id, presence: true
  has_many :stock_product_destinations
end
