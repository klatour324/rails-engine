class Api::V1::MerchantsController < ApplicationController
  # PER_PAGE = 20

  def index
    # Merchant.all.limit(per_page, page)
    page = params[:page] && params[:page].to_i >= 1 ? params.fetch(:page).to_i : 1
    per_page = params[:per_page] ? params.fetch(:per_page).to_i : 20
    render json: MerchantSerializer.new(Merchant.offset((page - 1) * per_page).limit(per_page))

    #Doug's findings
    # offset = (page.to_i - 1) * per_page.to_i
    # offset is the starting point of how many merchants we want to show on the page
    # limit limits how many merchants we show per page

    # all_merchants(page)
    #   page = 1 unless page
    #   per_page = 20 unless per_page
    # end

    # def page
    #   params.find(:page, 1).to_i
    # end
  end
end
