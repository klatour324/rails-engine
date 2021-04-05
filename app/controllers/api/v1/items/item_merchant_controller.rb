class Api::V1::Items::ItemMerchantController < ApplicationController
  def show
  item = Item.find(params[:item_id])
  item_merchant = item.merchant
  render json: MerchantSerializer.new(item_merchant)
  end
end
