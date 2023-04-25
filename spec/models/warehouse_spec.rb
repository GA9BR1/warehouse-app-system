require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when name is empty' do
        warehouse = Warehouse.new(name: '', code: 'RIO', address: 'Endereço',
                                  cep: '25000-000', city: 'Rio', area: 1000,
                                  description: 'Alguma descrição')
        expect(warehouse.valid?).to eq(false)
      end

      it 'false when code is empty' do
        warehouse = Warehouse.new(name: 'Rio de Janeiro', code: '', address: 'Endereço',
                                  cep: '25000-000', city: 'Rio', area: 1000,
                                  description: 'Alguma descrição')
        expect(warehouse.valid?).to eq(false)
      end

      it 'false when address is empty' do
        warehouse = Warehouse.new(name: 'Rio de Janeiro', code: 'RIO', address: '',
                                  cep: '25000-000', city: 'Rio', area: 1000,
                                  description: 'Alguma descrição')
        expect(warehouse.valid?).to eq(false)
      end

      it 'false when cep is empty' do
        warehouse = Warehouse.new(name: 'Rio de Janeiro', code: 'RIO', address: 'Endereço',
                                  cep: '', city: 'Rio', area: 1000,
                                  description: 'Alguma descrição')
        expect(warehouse.valid?).to eq(false)
      end

      it 'false when city is empty' do
        warehouse = Warehouse.new(name: 'Rio de Janeiro', code: 'RIO', address: 'Endereço',
                                  cep: '25000-000', city: '', area: 1000,
                                  description: 'Alguma descrição')
        expect(warehouse.valid?).to eq(false)
      end

      it 'false when area is empty' do
        warehouse = Warehouse.new(name: 'Rio de Janeiro', code: 'RIO', address: 'Endereço',
                                  cep: '25000-000', city: 'Rio', area: nil,
                                  description: 'Alguma descrição')
        expect(warehouse.valid?).to eq(false)
      end

      it 'false when description is empty' do
        warehouse = Warehouse.new(name: 'Rio de Janeiro', code: 'RIO', address: 'Endereço',
                                  cep: '25000-000', city: 'Rio', area: 1000,
                                  description: '')
        expect(warehouse.valid?).to eq(false)
      end
    end

    context 'unique' do
      it 'false when code is not unique' do
        Warehouse.create(name: 'Rio de Janeiro', code: 'RIO', address: 'Endereço',
                         cep: '25000-000', city: 'Rio', area: 1000,
                         description: 'Alguma descrição')

        warehouse = Warehouse.new(name: 'Goiás', code: 'RIO', address: 'Estrada',
                                  cep: '74453-000', city: 'Goiânia', area: 2000,
                                  description: 'Alguma desc')

        expect(warehouse.valid?).to eq(false)
      end
    end

    context 'format' do
      it 'false when code is not all in uppercase' do
        warehouse = Warehouse.new(name: 'Rio de Janeiro', code: 'Rio', address: 'Endereço',
                                  cep: '25000-000', city: 'Rio', area: 1000,
                                  description: 'Alguma descrição')

        expect(warehouse.valid?).to eq(false)
      end

      it 'false when code has numbers' do
        warehouse = Warehouse.new(name: 'Rio de Janeiro', code: 'R1O', address: 'Endereço',
                                  cep: '25000-000', city: 'Rio', area: 1000,
                                  description: 'Alguma descrição')
        expect(warehouse.valid?).to eq(false)
      end

      it 'false when code has not 3 digits' do
        warehouse = Warehouse.new(name: 'Rio de Janeiro', code: 'RIOO', address: 'Endereço',
                                  cep: '25000-000', city: 'Rio', area: 1000,
                                  description: 'Alguma descrição')
        expect(warehouse.valid?).to eq(false)
      end

      it 'false when cep doens\'t have (-)' do
        warehouse = Warehouse.new(name: 'Rio de Janeiro', code: 'RIO', address: 'Endereço',
                                  cep: '25000000', city: 'Rio', area: 1000,
                                  description: 'Alguma descrição')
        expect(warehouse.valid?).to eq(false)
      end

      it 'false when cep has not 9 chars' do
        warehouse = Warehouse.new(name: 'Rio de Janeiro', code: 'RIO', address: 'Endereço',
                                  cep: '250000-000', city: 'Rio', area: 1000,
                                  description: 'Alguma descrição')
        expect(warehouse.valid?).to eq(false)
      end

      it 'false when cep doens\'t have the (-) before the last 3 digits' do
        warehouse = Warehouse.new(name: 'Rio de Janeiro', code: 'RIO', address: 'Endereço',
                                  cep: '250000-00', city: 'Rio', area: 1000,
                                  description: 'Alguma descrição')
        expect(warehouse.valid?).to eq(false)
      end

      it 'false when cep has letters' do
        warehouse = Warehouse.new(name: 'Rio de Janeiro', code: 'RIO', address: 'Endereço',
                                  cep: '2500a-000', city: 'Rio', area: 1000,
                                  description: 'Alguma descrição')
        expect(warehouse.valid?).to eq(false)
      end
    end
  end
  describe '#full_description' do
    it 'exibe o nome fantasia e a razão social' do
      w = Warehouse.create!(name: 'Galpão Cuiabá', code: 'CBA', area: 10_000, cep: '56000-000',
                            city: 'Cuiabá', description: 'Galpão no centro do país',
                            address: 'Av dos Jacarés, 1000')

      expect(w.full_description).to eq('CBA - Galpão Cuiabá')
    end
  end
end
