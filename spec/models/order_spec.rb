require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid?' do 
    it 'deve ter um código' do
      user = User.create!(name: 'Sérgio Ramos', email: 'sergio@email.com', password: 'password')
      warehouse = Warehouse.create!(name: 'Cuiabá', code: 'CWB', area: 10_000, cep: '56000-000',
                        city: 'Cuiabá', description: 'Galpão no centro do país',
                        address: 'Av dos Jacarés, 1000')
      supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark',
                       registration_number: '45097902000126', full_address: 'Torre da Industria, 1',
                       city: 'Teresina', state: 'PI', email: 'industries@spark.com')
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: '2023-10-01')

      expect(order.valid?).to be true
    end
    
    it 'data estimada de entrega obrigatória' do
      order = Order.new(estimated_delivery_date: '')
      order.valid?
      expect(order.errors.include?(:estimated_delivery_date)).to be(true)
    end

    it 'data estimada de entrega não deve ser antiga' do
      order = Order.new(estimated_delivery_date: 1.day.ago)

      order.valid?
      expect(order.errors.include?(:estimated_delivery_date)).to be(true)
      expect(order.errors[:estimated_delivery_date]).to include(' deve ser futura')
    end

    it 'data estimada de entrega deve ser igual ou maior do que amanhã' do
    order = Order.new(estimated_delivery_date: 1.day.from_now)
    order.valid?
    expect(order.errors.include?(:estimated_delivery_date)).to be(false)
    end
  end
  describe 'gera um código aleatório' do
    it 'ao criar um novo pedido' do
    user = User.create!(name: 'Sérgio Ramos', email: 'sergio@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Cuiabá', code: 'CWB', area: 10_000, cep: '56000-000',
                      city: 'Cuiabá', description: 'Galpão no centro do país',
                      address: 'Av dos Jacarés, 1000')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark',
                     registration_number: '45097902000126', full_address: 'Torre da Industria, 1',
                     city: 'Teresina', state: 'PI', email: 'industries@spark.com')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: '2023-10-01')
    order.save!
    expect(order.code).not_to(be_empty)
    expect(order.code.length).to eq 8
    end
    it 'e o código é único' do
      user = User.create!(name: 'Sérgio Ramos', email: 'sergio@email.com', password: 'password')
      warehouse = Warehouse.create!(name: 'Cuiabá', code: 'CWB', area: 10_000, cep: '56000-000',
                        city: 'Cuiabá', description: 'Galpão no centro do país',
                        address: 'Av dos Jacarés, 1000')
      supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark',
                       registration_number: '45097902000126', full_address: 'Torre da Industria, 1',
                       city: 'Teresina', state: 'PI', email: 'industries@spark.com')
      first_order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: '2023-10-01')
      second_order = Order.new(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: '2023-11-15')
      second_order.save!
      expect(second_order.code).not_to eq(first_order.code)
      expect(second_order.code.length).to eq 8
    end
  end
end
