require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'class methods' do
    describe '::find_all_by_name_fragments' do
      it 'finds an all merchants by fragmented name searches' do
        merchant1 = create(:merchant, name: 'Harry')
        merchant2 = create(:merchant, name: 'Carry')
        merchant3 = create(:merchant, name: 'Scary')
        expect(Merchant.find_all_by_name_fragment('rry')).to eq([merchant2, merchant1])
      end
    end
  end
end
