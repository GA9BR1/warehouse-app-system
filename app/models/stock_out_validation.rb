class StockOutValidation < ApplicationRecord
  belongs_to :product_model

  validates :product_model, :quantity, :recipient, :address, presence: true
end
