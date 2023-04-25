require 'rails_helper'

describe 'Usuário edita pedido' do
  it 'e deve estar autenticado' do
    user = User.create!(name: 'João Almeida', email: 'joao@email.com', password: 'password')
    first_warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                      description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', 
                                registration_number: '45097902000126', full_address: 'Torre da Industria, 1',
                                city: 'Teresina', state: 'PI', email: 'industries@spark.com')
    order = Order.create!(user: user, warehouse: first_warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    visit edit_order_path(order.id)

    expect(current_path).to eq(new_user_session_path)
  end

  it 'com sucesso' do
    user = User.create!(name: 'João Almeida', email: 'joao@email.com', password: 'password')
    first_warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                      description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', 
                                registration_number: '45097902000126', full_address: 'Torre da Industria, 1',
                                city: 'Teresina', state: 'PI', email: 'industries@spark.com')
    Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Eletronicos LTDA',
                     registration_number: '09875171000139', full_address: 'Av Nações Unidas, 1000',
                     city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
    order = Order.create!(user: user, warehouse: first_warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Editar'
    fill_in 'Data Prevista de Entrega', with: '26/07/2023'
    select('Samsung Eletronicos LTDA', from: 'Fornecedor')
    click_on 'Gravar'

    expect(page).to have_content 'Pedido atualizado com sucesso.'
    expect(page).to have_content("Fornecedor: Samsung Eletronicos LTDA")
    expect(page).to have_content("Data Prevista de Entrega: 26/07/2023")
  end

  it 'caso seja o responsável' do 
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
    visit edit_order_path(order.id)

    expect(current_path).to eq(root_path)
  end
end