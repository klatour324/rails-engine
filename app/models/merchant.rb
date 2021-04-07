class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices


  def self.find_all_by_name_fragment(searched_term)
    where("lower(name) LIKE ?", "%#{searched_term}%")
    .order(:name)
  end

  def total_revenue
    transactions
    .where('invoices.status = ?', 'shipped')
    .where('transactions.result = ?', 'success')
    .pluck('(invoice_items.quantity * items.unit_price) AS total_merchant_revenue')
    .sum.round(2)
  end
end
