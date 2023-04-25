require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#description' do
    it 'exibe o nome e o email' do
      u = User.new(name: 'Julia Almeida', email: 'julia@yahoo.com', password: 'password')
      expect(u.description).to eq('Julia Almeida - julia@yahoo.com')
    end
  end
end
