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