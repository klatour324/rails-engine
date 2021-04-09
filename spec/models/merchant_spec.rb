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

    describe '::most_revenue(quantity)'  do
      it 'returns a quantity of merchants sorted by descending revenue' do
        merchant1 = create(:merchant, id: 1)
        customer1 = create(:customer, id: 1)
        item1 = create(:item, merchant_id: merchant1.id)
        item2 = create(:item, merchant_id: merchant1.id)
        item3 = create(:item, merchant_id: merchant1.id)
        item4 = create(:item, merchant_id: merchant1.id)
        invoice1 = create(:invoice, customer_id: customer1.id, merchant_id: merchant1.id, status: 'shipped')
        invoice2 = create(:invoice, customer_id: customer1.id, merchant_id: merchant1.id, status: 'shipped')
        invoice3 = create(:invoice, customer_id: customer1.id, merchant_id: merchant1.id, status: 'shipped')
        invoice4 = create(:invoice, customer_id: customer1.id, merchant_id: merchant1.id, status: 'shipped')
        invoice_item1 = create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, quantity: 10, unit_price:10.00)
        invoice_item2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice2.id, quantity: 10, unit_price:10.00)
        invoice_item3 = create(:invoice_item, item_id: item3.id, invoice_id: invoice3.id, quantity: 10, unit_price:10.00)
        invoice_item4 = create(:invoice_item, item_id: item4.id, invoice_id: invoice4.id, quantity: 10, unit_price:10.00)
        transaction1 = create(:transaction, invoice_id: invoice1.id, result: "success")
        transaction2 = create(:transaction, invoice_id: invoice2.id, result: "success")
        transaction3 = create(:transaction, invoice_id: invoice3.id, result: "success")
        transaction4 = create(:transaction, invoice_id: invoice4.id, result: "success")

        merchant2 = create(:merchant)
        customer2 = create(:customer)
        item5 = create(:item, merchant_id: merchant2.id)
        item6 = create(:item, merchant_id: merchant2.id)
        item7 = create(:item, merchant_id: merchant2.id)
        item8 = create(:item, merchant_id: merchant2.id)
        invoice5 = create(:invoice, customer_id: customer2.id, merchant_id: merchant2.id, status: 'shipped')
        invoice6 = create(:invoice, customer_id: customer2.id, merchant_id: merchant2.id, status: 'shipped')
        invoice7 = create(:invoice, customer_id: customer2.id, merchant_id: merchant2.id, status: 'shipped')
        invoice8 = create(:invoice, customer_id: customer2.id, merchant_id: merchant2.id, status: 'shipped')
        invoice_item5 = create(:invoice_item, item_id: item5.id, invoice_id: invoice5.id, quantity: 10, unit_price:10.00)
        invoice_item6 = create(:invoice_item, item_id: item6.id, invoice_id: invoice6.id, quantity: 10, unit_price:10.00)
        invoice_item7 = create(:invoice_item, item_id: item7.id, invoice_id: invoice7.id, quantity: 10, unit_price:10.00)
        invoice_item8 = create(:invoice_item, item_id: item8.id, invoice_id: invoice8.id, quantity: 10, unit_price:10.00)
        transaction5 = create(:transaction, invoice_id: invoice5.id, result: "failed")
        transaction6 = create(:transaction, invoice_id: invoice6.id, result: "success")
        transaction7 = create(:transaction, invoice_id: invoice7.id, result: "success")
        transaction8 = create(:transaction, invoice_id: invoice8.id, result: "failed")

        result = Merchant.most_revenue(2)

        expect(result.length).to eq(2)
      end
    end
  end

  describe 'instance methods' do
    describe '#total_revenue' do
      it 'calculates and returns the total revenue for a given merchant' do
        merchant1 = create(:merchant, id: 1)
        customer1 = create(:customer, id: 1)
        item1 = create(:item, merchant_id: merchant1.id)
        item2 = create(:item, merchant_id: merchant1.id)
        item3 = create(:item, merchant_id: merchant1.id)
        item4 = create(:item, merchant_id: merchant1.id)
        invoice1 = create(:invoice, customer_id: customer1.id, merchant_id: merchant1.id, status: 'shipped')
        invoice2 = create(:invoice, customer_id: customer1.id, merchant_id: merchant1.id, status: 'shipped')
        invoice3 = create(:invoice, customer_id: customer1.id, merchant_id: merchant1.id, status: 'shipped')
        invoice4 = create(:invoice, customer_id: customer1.id, merchant_id: merchant1.id, status: 'shipped')
        invoice_item1 = create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, quantity: 10, unit_price:10.00)
        invoice_item2 = create(:invoice_item, item_id: item2.id, invoice_id: invoice2.id, quantity: 10, unit_price:10.00)
        invoice_item3 = create(:invoice_item, item_id: item3.id, invoice_id: invoice3.id, quantity: 10, unit_price:10.00)
        invoice_item4 = create(:invoice_item, item_id: item4.id, invoice_id: invoice4.id, quantity: 10, unit_price:10.00)
        transaction1 = create(:transaction, invoice_id: invoice1.id, result: "success")
        transaction2 = create(:transaction, invoice_id: invoice2.id, result: "success")
        transaction3 = create(:transaction, invoice_id: invoice3.id, result: "success")
        transaction4 = create(:transaction, invoice_id: invoice4.id, result: "success")

        result = merchant1.total_revenue
        expect(result).to eq(400.00)
      end
    end
  end
end
