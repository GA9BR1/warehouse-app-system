class Warehouse < ApplicationRecord
  validates :name, :code, :description, :address, :city, :cep, :area, presence: true
  validates :code, length: { is: 3 }
  validates :code, uniqueness: { case_sensitive: false }
  validates :code, format: { with: /\A[A-Z]+\z/, message: 'deve conter apenas letras maiúsculas' }
  validates :cep, length: { is: 9 }
  validates :cep, format: { with: /\A\d+-\d{3}\z/ }
  validates :area, numericality: true

  def full_description
    "#{code} - #{name}"
  end 
end
