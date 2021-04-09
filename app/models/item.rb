class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates_presence_of [:name, :description, :unit_price, :merchant_id], on: :create

  def self.find_item_by_name_fragment(searched_term)
    where("name ILIKE?", "%#{searched_term}%")
    .order(:name)
    .limit(1)
    .first
  end

  def self.find_by_min_and_max_price(min_price, max_price)
    where('unit_price <= ?', max_price )
    .where('unit_price >= ?', min_price)
    .order(:name)
    .limit(1)
    .first
  end

  def self.items_most_revenue(quantity)
    select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
    .joins(:transactions)
    .where(transactions: {result: :success})
    .group(:id)
    .order(revenue: :desc)
    .limit(quantity)
  end

  def self.find_by_max_price(max_price)
    where('unit_price <= ?', max_price )
    .order(:name)
    .limit(1)
    .first
  end

  def self.find_by_min_price(min_price)
    where('unit_price >= ?', min_price)
    .order(:name)
    .limit(1)
    .first
  end
end
