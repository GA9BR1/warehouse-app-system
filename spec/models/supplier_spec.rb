require 'rails_helper'

RSpec.describe Supplier, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when corporate_name is empty' do
        supplier = Supplier.new(corporate_name: '', brand_name: 'ACME', 
                                registration_number: '28260675000199', full_address: 'Av das Palmas, 100',
                                city: 'Bauru', state: 'SP', email: 'contato@acmeltda.com')
        expect(supplier.valid?).to eq(false)
      end

      it 'false when brand_name is empty' do
        supplier = Supplier.new(corporate_name: 'ACME LTDA', brand_name: '', 
                                registration_number: '28260675000199', full_address: 'Av das Palmas, 100',
                                city: 'Bauru', state: 'SP', email: 'contato@acmeltda.com')
        expect(supplier.valid?).to eq(false)
      end

      it 'false when registration_number is empty' do
        supplier = Supplier.new(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                registration_number: '', full_address: 'Av das Palmas, 100',
                                city: 'Bauru', state: 'SP', email: 'contato@acmeltda.com')
        expect(supplier.valid?).to eq(false)
      end

      it 'false when full_address is empty' do
        supplier = Supplier.new(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                registration_number: '28260675000199', full_address: '',
                                city: 'Bauru', state: 'SP', email: 'contato@acmeltda.com')
        expect(supplier.valid?).to eq(false)
      end

      it 'false when city is empty' do
        supplier = Supplier.new(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                registration_number: '28260675000199', full_address: 'Av das Palmas, 100',
                                city: '', state: 'SP', email: 'contato@acmeltda.com')
        expect(supplier.valid?).to eq(false)
      end

      it 'false when state is empty' do
        supplier = Supplier.new(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                registration_number: '28260675000199', full_address: 'Av das Palmas, 100',
                                city: 'Bauru', state: '', email: 'contato@acmeltda.com')
        expect(supplier.valid?).to eq(false)
      end

      it 'false when email is empty' do
        supplier = Supplier.new(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                registration_number: '28260675000199', full_address: 'Av das Palmas, 100',
                                city: 'Bauru', state: 'SP', email: '')
        expect(supplier.valid?).to eq(false)
      end
    end

    context 'unique' do
      it 'false when registration_number is not unique' do
        Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME',
                         registration_number: '28260675000199', full_address: 'Av das Palmas, 100',
                         city: 'Bauru', state: 'SP', email: 'contato@acmeltda.com')
        s = Supplier.new(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark',
                         registration_number: '28260675000199', full_address: 'Torre da Industria, 1',
                         city: 'Teresina', state: 'PI', email: 'industries@spark.com')
        expect(s.valid?).to eq(false)
      end
    end

    context 'format' do
      it 'false when state has not 2 chars' do
        supplier = Supplier.new(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                registration_number: '28260675000199', full_address: 'Av das Palmas, 100',
                                city: 'Bauru', state: 'SPP', email: 'contato@acmeltda.com')
        expect(supplier.valid?).to eq(false)
      end
      it 'false when state is not all in uppercase' do
        supplier = Supplier.new(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                registration_number: '28260675000199', full_address: 'Av das Palmas, 100',
                                city: 'Bauru', state: 'Sp', email: 'contato@acmeltda.com')
        expect(supplier.valid?).to eq(false)
      end
      it 'false when registration_number has not 14 numbers' do
        supplier = Supplier.new(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                registration_number: '2826067500019', full_address: 'Av das Palmas, 100',
                                city: 'Bauru', state: 'SP', email: 'contato@acmeltda.com')
        expect(supplier.valid?).to eq(false)
      end
    end
  end
end
