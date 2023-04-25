require 'rails_helper'

describe 'Usuário vê fornecedores' do
  it 'a partir do menu' do
    visit root_path
    within 'nav' do
      click_on 'Fornecedores'
    end
    expect(current_path).to eq suppliers_path
  end

  it 'com sucesso' do
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                     registration_number: '28260675000199', full_address: 'Av das Palmas, 100',
                     city: 'Bauru', state: 'SP', email: 'contato@acmeltda.com')
    Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', 
                     registration_number: '45097902000126', full_address: 'Torre da Industria, 1',
                     city: 'Teresina', state: 'PI', email: 'industries@spark.com')

    visit root_path
    click_on 'Fornecedores'

    expect(page).to have_content('Fornecedores')
    expect(page).to have_content('ACME')
    expect(page).to have_content('Bauru - SP')
    expect(page).to have_content('Spark')
  end

  it 'e não existem fornecedores cadastrados' do
    visit root_path
    click_on 'Fornecedores'
    expect(page).to have_content('Não existem fornecedores cadastrados')
  end 
end