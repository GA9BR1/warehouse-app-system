require 'rails_helper'

describe 'Usuário se autentica' do
  it 'com sucesso' do
    User.create!(name: 'João Silva', email: 'joao@email.com', password: 'password')
    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: 'joao@email.com'
    fill_in 'Senha', with: 'password'
    within('form') do
      click_on 'Entrar'
    end
    expect(page).to have_content 'Login efetuado com sucesso'
    within('nav') do
      expect(page).not_to have_link('Entrar')
      expect(page).to have_button('Sair')
      expect(page).to have_content('Olá João Silva - joao@email.com')
    end
  end
  it 'e faz logout' do
    User.create!(name: 'João', email: 'joao@email.com', password: 'password')
    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: 'joao@email.com'
    fill_in 'Senha', with: 'password'
    within('form') do
      click_on 'Entrar'
    end
    click_on 'Sair'
    expect(page).to have_content 'Logout efetuado com sucesso'
    expect(page).not_to have_button 'Sair'
    expect(page).not_to have_content 'Olá João'
  end
end