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

    describe '::find_by_min_and_max_price' do
      it 'finds the item between the min and max price, sorted alphabetically' do
        merchant = create(:merchant)
        item1 = create(:item, name: 'Cool Item', merchant: merchant, unit_price: 100.00)
        item2 = create(:item, name: 'Best Item', merchant: merchant, unit_price: 150.00)
        item3 = create(:item, name: 'Only Item', merchant: merchant, unit_price: 300.00)

        expect(Item.find_by_min_and_max_price(100.00, 300.00)).to eq(item2)
      end
    end

    describe '::find_by_max_price' do
      it 'finds the item by its max price' do
        merchant = create(:merchant)
        item1 = create(:item, name: 'Cool Item', merchant: merchant, unit_price: 100.00)
        item2 = create(:item, name: 'Best Item', merchant: merchant, unit_price: 250.00)
        item3 = create(:item, name: 'A Really Cool Item', merchant: merchant, unit_price: 150.00)

        expect(Item.find_by_max_price(200.00)).to eq(item3)
      end
    end

    describe '::find_by_min_price' do
      it 'finds the item by its min price' do
        merchant = create(:merchant)
        item1 = create(:item, name: 'Cool Item', merchant: merchant, unit_price: 200.00)
        item2 = create(:item, name: 'Best Item', merchant: merchant, unit_price: 100.00)
        item3 = create(:item, name: 'Only Item', merchant: merchant, unit_price: 300.00)

        expect(Item.find_by_min_price(100.00)).to eq(item2)
      end
    end
  end
end
