class Api::V1::ItemsController < ApplicationController
  def index
    page = params[:page] && params[:page].to_i >= 1 ? params.fetch(:page).to_i : 1
    per_page = params[:per_page] ? params.fetch(:per_page).to_i : 20
    render json: ItemSerializer.new(Item.offset((page - 1) * per_page).limit(per_page))
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: :created
    else
      render json: { message: "Your query could not be completed", errors: item.errors.full_messages }, status: :not_acceptable
    end
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: ItemSerializer.new(item), status: :accepted
    else
      render json: { message: "Your query could not be completed", errors: item.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    item_id = Item.find(params[:id])
    invoice_ids = item.invoice_items.select('invoice_items.invoice_id')
    invoices = InvoiceItem.where('invoice_id in (?)', invoice_ids).group(:invoice_id).count
    invoices.each do |invoice_id, item_count|
      if item_count == 1
        Invoice.destroy(invoice_id)
      end
    end
    render json: Item.destroy(params[:id])
    # Invoice.destroy_invoice_with_one_item(item_id)
  end

  def top_revenue
    quantity = params[:quantity].nil? ? 10 : params[:quantity].to_i

    if quantity <= 0
      error = "invalid quantity parameter, it must be an integer greater than 0"
      render json: { error: error}, status: :bad_request
    else
      @item = Item.items_most_revenue(quantity)
      render json: ItemRevenueSerializer.new(@item)
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
