require 'rails_helper'

describe 'Usuário busca por um pedido' do
  it 'a partir do menu' do
    user = User.create!(name: 'João Almeida', email: 'joao@email.com', password: 'password')
    login_as(user)
    visit root_path
    within('header nav') do
      expect(page).to have_field('Buscar Pedido')
      expect(page).to have_button('Buscar')
    end
  end
  it 'e deve estar autenticado' do
    visit root_path
    within('header nav') do
      expect(page).not_to have_field('Buscar Pedido')
      expect(page).not_to have_button('Buscar')
    end
  end
  it 'e econtra um pedido' do
    user = User.create!(name: 'João Almeida', email: 'joao@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                      address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                      description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', 
                     registration_number: '45097902000126', full_address: 'Torre da Industria, 1',
                     city: 'Teresina', state: 'PI', email: 'industries@spark.com')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    login_as(user)
    visit root_path
    fill_in 'Buscar Pedido', with: order.code
    click_on 'Buscar'
    expect(page).to have_content "Resultados da Busca por: #{order.code}"
    expect(page).to have_content '1 pedido encontrado'
    expect(page).to have_content "Código: #{order.code}"
    expect(page).to have_content "Galpão Destino: GRU - Aeroporto SP"
    expect(page).to have_content "Fornecedor: Spark Industries Brasil LTDA"
  end
  it 'e encontra multiplos pedidos' do
    user = User.create!(name: 'João Almeida', email: 'joao@email.com', password: 'password')
    first_warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                      description: 'Galpão destinado para cargas internacionais')
    second_warehouse = Warehouse.create!(name: 'Aeroporto Rio', code: 'SDU', city: 'Rio de Janeiro', area: 70_000,
                                         address: 'Avenida do Porto, 80', cep: '25000-000',
                                         description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', 
                                registration_number: '45097902000126', full_address: 'Torre da Industria, 1',
                                city: 'Teresina', state: 'PI', email: 'industries@spark.com')

    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('GRU12345')
    Order.create!(user: user, warehouse: first_warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('GRU98765')
    Order.create!(user: user, warehouse: first_warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('SDU00000')
    Order.create!(user: user, warehouse: second_warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
      
    login_as(user)
    visit root_path
    fill_in 'Buscar Pedido', with: 'GRU'
    click_on 'Buscar'

    expect(page).to have_content('2 pedidos encontrados')
    expect(page).to have_content('GRU12345')
    expect(page).to have_content('GRU98765')
    expect(page).to have_content "Galpão Destino: GRU - Aeroporto SP"
    expect(page).not_to have_content('SDU00000')
    expect(page).not_to have_content("Galpão Destino: SDU - Aeroporto Rio")
  end
end