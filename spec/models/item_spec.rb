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
  end
end
