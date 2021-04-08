require 'rails_helper'
RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name).on(:create) }
    it { should validate_presence_of(:description).on(:create) }
    it { should validate_presence_of(:unit_price).on(:create) }
  end

  describe 'class methods' do
    describe '::find_item_by_name_fragment' do
      it 'finds an item by fragmented name searches' do
        item1 = create(:item, name: 'Cool Item')
        item2 = create(:item, name: 'Not So Cool Item')
        expect(Item.find_item_by_name_fragment('item')).to eq(item1)
      end
    end

    describe '::items_most_revenue' do
      it 'returns the item with the most revenue' do
        merchant = create(:merchant, id: 1)
        item1 = create(:item, merchant: merchant)
        item2 = create(:item, merchant: merchant)
        item3 = create(:item, merchant: merchant)
        invoice = create(:invoice)
        invoice_item1 = create(:invoice_item, invoice: invoice, item: item1, quantity: 10)
        invoice_item2 = create(:invoice_item, invoice: invoice, item: item2, quantity: 20)
        invoice_item3 = create(:invoice_item, invoice: invoice, item: item3, quantity: 30)
        transaction = create(:transaction, invoice: invoice, result: :success)

        expect(Item.items_most_revenue(3)).to eq([item3, item2, item1])
      end
    end
  end
end
