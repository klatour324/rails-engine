class Api::V1::Merchants::SearchController < ApplicationController
  def index
    merchants = Merchant.find_all_by_name_fragment(params[:name].downcase)
    render json: MerchantSerializer.new(merchants)
  end
end
