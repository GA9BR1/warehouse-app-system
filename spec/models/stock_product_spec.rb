require 'rails_helper'

RSpec.describe StockProduct, type: :model do
  describe 'gera um número de série' do
    it 'ao criar um StockProduct' do 
      user = User.create!(name: 'Sérgio Ramos', email: 'sergio@email.com', password: 'password')
      warehouse = Warehouse.create!(name: 'Cuiabá', code: 'CWB', area: 10_000, cep: '56000-000',
                        city: 'Cuiabá', description: 'Galpão no centro do país',
                        address: 'Av dos Jacarés, 1000')
      supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark',
                       registration_number: '45097902000126', full_address: 'Torre da Industria, 1',
                       city: 'Teresina', state: 'PI', email: 'industries@spark.com')
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.week.from_now, status: :delivered)

      product = ProductModel.create!(name: 'Cadeira Gamer', supplier: supplier, weight: 5, height: 70, width: 75, depth: 80, sku: 'CGMER-XPTO-888')

      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)
      expect(stock_product.serial_number.length).to eq(20)
    end

    it 'e não é modificado' do
      user = User.create!(name: 'Sérgio Ramos', email: 'sergio@email.com', password: 'password')
      warehouse = Warehouse.create!(name: 'Cuiabá', code: 'CWB', area: 10_000, cep: '56000-000',
                                    city: 'Cuiabá', description: 'Galpão no centro do país',
                                    address: 'Av dos Jacarés, 1000')
      other_warehouse = Warehouse.create!(name: 'Guarulhos', code: 'GRU', area: 1000, cep: '16000-000',
                                          city: 'Guarulhos', description: 'Galpão de SP',
                                          address: 'Endereço')
      supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark',
                                  registration_number: '45097902000126', full_address: 'Torre da Industria, 1',
                                  city: 'Teresina', state: 'PI', email: 'industries@spark.com')
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier,
                            estimated_delivery_date: 1.week.from_now, status: :delivered)

      product = ProductModel.create!(name: 'Cadeira Gamer', supplier: supplier, weight: 5, height: 70, width: 75,
                                     depth: 80, sku: 'CGMER-XPTO-888')

      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)

      original_serial_number = stock_product.serial_number
      stock_product.update(warehouse: other_warehouse)

      expect(stock_product.serial_number).to eq(original_serial_number)
    end
  end

  describe '#available?' do
    it 'true se não tiver destino' do
      user = User.create!(name: 'Sérgio Ramos', email: 'sergio@email.com', password: 'password')
      warehouse = Warehouse.create!(name: 'Cuiabá', code: 'CWB', area: 10_000, cep: '56000-000',
                        city: 'Cuiabá', description: 'Galpão no centro do país',
                        address: 'Av dos Jacarés, 1000')
      supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark',
                       registration_number: '45097902000126', full_address: 'Torre da Industria, 1',
                       city: 'Teresina', state: 'PI', email: 'industries@spark.com')
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.week.from_now, status: :delivered)

      product = ProductModel.create!(name: 'Cadeira Gamer', supplier: supplier, weight: 5, height: 70, width: 75, depth: 80, sku: 'CGMER-XPTO-888')

      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)

      expect(stock_product.available?).to eq(true)
    end
    
    it 'false se tiver destino' do
      user = User.create!(name: 'Sérgio Ramos', email: 'sergio@email.com', password: 'password')
      warehouse = Warehouse.create!(name: 'Cuiabá', code: 'CWB', area: 10_000, cep: '56000-000',
                        city: 'Cuiabá', description: 'Galpão no centro do país',
                        address: 'Av dos Jacarés, 1000')
      supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark',
                       registration_number: '45097902000126', full_address: 'Torre da Industria, 1',
                       city: 'Teresina', state: 'PI', email: 'industries@spark.com')
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.week.from_now, status: :delivered)

      product = ProductModel.create!(name: 'Cadeira Gamer', supplier: supplier, weight: 5, height: 70, width: 75, depth: 80, sku: 'CGMER-XPTO-888')

      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)
      stock_product.create_stock_product_destination!(recipient: 'João', address: 'Rua do João')

      expect(stock_product.available?).to eq(false)
    end
  end
end
