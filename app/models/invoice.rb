class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :transactions
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  # def self.destroy_invoice_with_one_item(item_id)
  #   item_id = Item.find(params[:id])
  #   invoice_ids = item.invoice_items.select('invoice_items.invoice_id')
  #   invoices = InvoiceItem.where('invoice_id in (?)', invoice_ids).group(:invoice_id).count
  #   invoices.each do |invoice_id, item_count|
  #     if item_count == 1
  #       Invoice.destroy(invoice_id)
  #     end
  #   end
  #   render json: Item.destroy(params[:id])
  # end

  def self.potential_revenue_unshipped(quantity)
    select('invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) as potential_revenue')
    .joins(:invoice_items)
    .where('invoices.status = ?', 'packaged')
    .group('invoices.id')
    .order('potential_revenue desc')
    .limit(quantity)
  end
end
