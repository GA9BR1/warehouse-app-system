require 'rails_helper'

describe 'Usuário edita um pedido' do
  it 'e não é o dono' do
    user = User.create!(name: 'João Almeida', email: 'joao@email.com', password: 'password')
    user2 = User.create!(name: 'André', email: 'andre@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                      description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', 
                                registration_number: '45097902000126', full_address: 'Torre da Industria, 1',
                                city: 'Teresina', state: 'PI', email: 'industries@spark.com')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    login_as(user2)
    patch(order_path(order.id), params: {order: {supplier_id: 3}})

    expect(response).to redirect_to(root_path)
  end
  
  it 'e não está autenticada' do
    user = User.create!(name: 'João Almeida', email: 'joao@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                      description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', 
                                registration_number: '45097902000126', full_address: 'Torre da Industria, 1',
                                city: 'Teresina', state: 'PI', email: 'industries@spark.com')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    patch(order_path(order.id), params: {order: {supplier_id: 3}})

    expect(response).to redirect_to(new_user_session_path)
  end
end
describe 'Usuário cria dados' do
  context 'cria um stock_product_destination ' do
    it 'e não está autenticado' do
      user = User.create!(name: 'João Almeida', email: 'joao@email.com', password: 'password')
      w = Warehouse.create(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                           address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                           description: 'Galpão destinado para cargas internacionais')
      s = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Eletronicos LTDA',
                           registration_number: '09875171000139', full_address: 'Av Nações Unidas, 1000',
                           city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
      order = Order.create!(user: user, supplier: s, warehouse: w, estimated_delivery_date: 1.day.from_now)
      produto_tv = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10,
                                        sku: 'TV32-SAMSU-XPTO90', supplier: s)
      3.times { StockProduct.create!(order: order, warehouse: w, product_model: produto_tv) }

      post(warehouse_stock_product_destinations_path(w.id), params: { stock_out_validation:
                                                                    { product_model_id: 1, quantity: 2,
                                                                      recipient: 'Gust',
                                                                      address: 'Rua dos Girassois' },
                                                                      warehouse_id: w.id })
      expect(StockProductDestination.all.empty?).to eq(true)
    end
  end
end