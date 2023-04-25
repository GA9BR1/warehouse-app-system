require 'rails_helper'

describe 'Usuário vê os detalhes do fornecedor' do
  it 'a partir da tela inicial' do
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                     registration_number: '28260675000199', full_address: 'Av das Palmas, 100',
                     city: 'Bauru', state: 'SP', email: 'contato@acmeltda.com')
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACME'

    expect(page).to have_content('ACME LTDA')
    expect(page).to have_content('Documento: 28260675000199')
    expect(page).to have_content('Endereço: Av das Palmas, 100 - Bauru - SP')
    expect(page).to have_content('E-mail: contato@acmeltda.com')
  end
end
