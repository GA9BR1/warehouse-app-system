class Supplier < ApplicationRecord
  has_many :product_models

  validates :corporate_name, :brand_name, :registration_number, :full_address, :city, :state, :email, presence: true
  validates :registration_number, numericality: true
  validates :registration_number, uniqueness: true
  validates :registration_number, length: { is: 14 }
  validates :state, length: { is: 2 }
  validates :state, format: { with: /\A[A-Z]+\z/, message: 'deve conter apenas letras maiúsculas' }
end
