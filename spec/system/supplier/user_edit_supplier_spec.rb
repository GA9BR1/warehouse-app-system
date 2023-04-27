require 'rails_helper'

describe 'Usuário edita um fornecedor' do
  it 'A partir da página de detalhes' do
    user = User.create!(name: 'André', email: 'andre@email.com', password: 'password')
    login_as(user)
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                     registration_number: '28260675000199', full_address: 'Av das Palmas, 100',
                     city: 'Bauru', state: 'SP', email: 'contato@acmeltda.com')
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACME'
    click_on 'Editar'

    expect(page).to have_field('Razão Social', with: 'ACME LTDA')
    expect(page).to have_field('Nome Fantasia', with: 'ACME')
    expect(page).to have_field('Endereço', with: 'Av das Palmas, 100')
    expect(page).to have_field('CNPJ', with: '28260675000199')
    expect(page).to have_field('Cidade', with: 'Bauru')
    expect(page).to have_field('Estado', with: 'SP')
    expect(page).to have_field('E-mail', with: 'contato@acmeltda.com')
  end

  it 'com sucesso' do
    user = User.create!(name: 'André', email: 'andre@email.com', password: 'password')
    login_as(user)
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                     registration_number: '28260675000199', full_address: 'Av das Palmas, 100',
                     city: 'Bauru', state: 'SP', email: 'contato@acmeltda.com')
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACME'
    click_on 'Editar'

    fill_in 'Cidade', with: 'Goiânia'
    fill_in 'Estado', with: 'GO'
    click_on 'Enviar'

    expect(page).to have_content('Fornecedor atualizado com sucesso')
    expect(page).to have_content('Goiânia')
    expect(page).to have_content('GO')
    expect(page).to have_content('ACME LTDA')
  end

  it 'e mantêm os campos obrigatórios' do
    user = User.create!(name: 'André', email: 'andre@email.com', password: 'password')
    login_as(user)
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                     registration_number: '28260675000199', full_address: 'Av das Palmas, 100',
                     city: 'Bauru', state: 'SP', email: 'contato@acmeltda.com')
    
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACME'
    click_on 'Editar'

    fill_in 'Razão Social', with: ''
    fill_in 'CNPJ', with: ''
    fill_in 'Cidade', with: ''
    click_on 'Enviar'

    expect(page).to have_content('Não foi possível atualizar o fornecedor')
  end
end