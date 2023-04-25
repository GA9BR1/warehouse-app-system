require 'rails_helper'

describe 'Usuário cadastra um pedido' do
  it 'e deve estar autenticado' do
    visit root_path
    click_on 'Registrar Pedido'

    expect(current_path).to eq(new_user_session_path)
  end 
  it 'com sucesso' do
    user = User.create!(name: 'Sérgio', email: 'sergio@email.com', password: 'password')
    Warehouse.create!(name: 'Cuiabá', code: 'CWB', area: 10_000, cep: '56000-000',
                      city: 'Cuiabá', description: 'Galpão no centro do país',
                      address: 'Av dos Jacarés, 1000')
    Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                      address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                      description: 'Galpão destinado para cargas internacionais')
    Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', 
                     registration_number: '45097902000126', full_address: 'Torre da Industria, 1',
                     city: 'Teresina', state: 'PI', email: 'industries@spark.com')
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME',
                     registration_number: '28260675000199', full_address: 'Av das Palmas, 100',
                     city: 'Bauru', state: 'SP', email: 'contato@acmeltda.com')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')
    login_as(user)
    visit root_path
    click_on 'Registrar Pedido'
    select 'GRU - Aeroporto SP', from: 'Galpão Destino'
    select 'ACME LTDA', from: 'Fornecedor'
    fill_in 'Data Prevista de Entrega', with: '05/05/2023'
    click_on 'Gravar'

    expect(page).to have_content 'Pedido registrado com sucesso'
    expect(page).to have_content 'Pedido ABC12345'
    expect(page).to have_content 'Galpão Destino: GRU - Aeroporto SP'
    expect(page).to have_content 'Fornecedor: ACME LTDA'
    expect(page).to have_content 'Usuário Responsável: Sérgio - sergio@email.com'
    expect(page).to have_content 'Data Prevista de Entrega: 05/05/2023'
    expect(page).to have_content 'Situação do Pedido: Pendente'
  end

  it 'não informa a data de entrega' do
    user = User.create!(name: 'Sérgio', email: 'sergio@email.com', password: 'password')
    Warehouse.create!(name: 'Cuiabá', code: 'CWB', area: 10_000, cep: '56000-000',
                      city: 'Cuiabá', description: 'Galpão no centro do país',
                      address: 'Av dos Jacarés, 1000')
    Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', 
                     registration_number: '45097902000126', full_address: 'Torre da Industria, 1',
                     city: 'Teresina', state: 'PI', email: 'industries@spark.com')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')
    login_as(user)
    visit root_path
    click_on 'Registrar Pedido'
    select 'CWB - Cuiabá', from: 'Galpão Destino'
    select 'Spark Industries Brasil LTDA', from: 'Fornecedor'
    fill_in 'Data Prevista de Entrega', with: ''
    click_on 'Gravar'

    expect(page).to have_content('Não foi possível registrar o pedido')
  end
end