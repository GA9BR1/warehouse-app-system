require 'rails_helper'

describe 'Usuário vê seus próprios pedidos' do
  it 'e deve estar autenticado' do
    visit root_path
    click_on 'Meus Pedidos'
    expect(current_path).to eq(new_user_session_path)
  end

  it 'e não vê outros pedidos' do
    user = User.create!(name: 'João Almeida', email: 'joao@email.com', password: 'password')
    other_user = User.create!(name: 'Carla', email: 'carla@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', 
                     registration_number: '45097902000126', full_address: 'Torre da Industria, 1',
                     city: 'Teresina', state: 'PI', email: 'industries@spark.com')

    first_order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now, status: :pending)
    second_order = Order.create!(user: other_user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now, status: :delivered)
    third_order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now, status: :canceled)

    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    expect(page).to have_content(first_order.code)
    expect(page).to have_content('Pendente')
    expect(page).not_to have_content(second_order.code)
    expect(page).not_to have_content('Entregue')
    expect(page).to have_content(third_order.code)
    expect(page).to have_content('Cancelado')
  end

  it 'e visita um pedido' do
    user = User.create!(name: 'João Almeida', email: 'joao@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', 
                                registration_number: '45097902000126', full_address: 'Torre da Industria, 1',
                                city: 'Teresina', state: 'PI', email: 'industries@spark.com')
    first_order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    click_on first_order.code

    expect(page).to have_content('Detalhes do Pedido')
    expect(page).to have_content(first_order.code)
    expect(page).to have_content("Galpão Destino: GRU - Aeroporto SP")
    expect(page).to have_content("Fornecedor: Spark Industries Brasil LTDA")
    expect(page).to have_content("Data Prevista de Entrega: #{I18n.localize(first_order.estimated_delivery_date)}")
  end

  it 'e não visita pedidos de outros usuários' do
    user = User.create!(name: 'André', email: 'andre@email.com', password: 'password')
    user2 = User.create!(name: 'João Almeida', email: 'joao@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', 
                                registration_number: '45097902000126', full_address: 'Torre da Industria, 1',
                                city: 'Teresina', state: 'PI', email: 'industries@spark.com')
    first_order = Order.create!(user: user2, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    login_as(user)
    visit order_path(first_order.id)

    expect(current_path).not_to eq(order_path(first_order.id))
    expect(current_path).to eq(root_path)
    expect(page).to have_content('Você não possuí acesso a este pedido.')
  end

  it 'e vê itens do pedido' do
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', 
                                registration_number: '45097902000126', full_address: 'Torre da Industria, 1',
                                city: 'Teresina', state: 'PI', email: 'industries@spark.com')

    product_a = ProductModel.create!(name: 'Produto A', weight: 1, width: 15, height: 20, depth: 30, supplier: supplier, sku: 'PRODUTO-A')
    product_b = ProductModel.create!(name: 'Produto B', weight: 1, width: 15, height: 20, depth: 30, supplier: supplier, sku: 'PRODUTO-B')
    product_c = ProductModel.create!(name: 'Produto C', weight: 1, width: 15, height: 20, depth: 30, supplier: supplier, sku: 'PRODUTO-C')

    user = User.create!(name: 'João Almeida', email: 'joao@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    OrderItem.create!(product_model: product_a, order: order, quantity: 19)
    OrderItem.create!(product_model: product_b, order: order, quantity: 12)
    
    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code

    expect(page).to have_content('Itens do Pedido')
    expect(page).to have_content('19 x Produto A')
    expect(page).to have_content('12 x Produto B')
  end
end