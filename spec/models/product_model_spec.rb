require 'rails_helper'

RSpec.describe ProductModel, type: :model do
  describe '#valid?' do
    it 'name presence' do
      s = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Eletronicos LTDA',
                           registration_number: '09875171000139', full_address: 'Av Nações Unidas, 1000',
                           city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
      pm = ProductModel.new(name: '', weight: 8000, width: 70, height: 45, depth: 10, sku: 'TV32-SAMSU-XPTO90', supplier: s) 
      expect(pm.valid?).to eq(false)
    end
    it 'sku presence' do
      s = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Eletronicos LTDA',
                           registration_number: '09875171000139', full_address: 'Av Nações Unidas, 1000',
                           city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
      pm = ProductModel.new(name: '', weight: 8000, width: 70, height: 45, depth: 10, sku: 'TV32-SAMSU-XPTO90', supplier: s) 
      expect(pm.valid?).to eq(false)
    end
  end
end
