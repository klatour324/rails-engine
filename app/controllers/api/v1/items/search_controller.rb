class Api::V1::Items::SearchController < ApplicationController
  include Findable

  def show
    name = params[:name]
    min_price = params[:min_price]
    max_price = params[:max_price]

    if name && (min_price || max_price)
      error = "please send name or min and max price"
      failure(error)
    elsif name
      search_by_name(name)
    elsif min_price && max_price
      find_min_and_max_price(min_price, max_price)
    elsif max_price
      find_max_price(max_price)
    elsif min_price
      find_min_price(min_price)
    else
      error = "please send a query parameter"
      failure(error)
    end
  end
end
