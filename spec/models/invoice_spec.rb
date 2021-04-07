require 'rails_helper'
RSpec.describe Invoice, type: :model do
  before :each do
    seed_test_db
  end
  describe 'relationships' do
    it { should belong_to :customer }
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many :transactions }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
  end

  describe 'class methods' do

    describe '::potential_revenue_unshipped' do
      it 'finds the total potential revenue of unshipped invoices' do
        results = Invoice.potential_revenue_unshipped(100)

        expect(results.first).to eq(@invoice6)
        expect(results.first.potential_revenue).to eq(0.2077e5)
        expect(results.last).to eq(@invoice9)
        expect(results.last.potential_revenue).to eq(0.101e3)
      end
    end

  end
end
