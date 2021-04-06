class Api::V1::Items::SearchController < ApplicationController
  def show
    name = params[:name]
    min_price = params[:min_price]
    max_price = params[:max_price]

    if name && (min_price || max_price)
      error = "please send name or min and or max price"
      failed_response(error)
    elsif name
      item = search_by_name(name)
      successful_response(item)
    elsif min_price && max_price
      find_by_max_and_min_price(min_price, max_price)
    elsif max_price
      find_max_price(max_price)
    elsif min_price
      find_min_price(min_price)
    else
      error = "please send a query parameter"
      failed_response(error)
    end
  end

  def successful_response(item)
   item ? (render json: ItemSerializer.new(item)) : (render json: {data: {}})
  end

  def failed_response(error)
    render json: { error: error}, status: :bad_request
  end

  def search_by_name(name)
    search_term = name.downcase
    item = Item.find_item_by_name_fragment(search_term)
  end

  def find_by_max_and_min_price(min_price, max_price)
    item = Item.where('unit_price <= ?', max_price ).where('unit_price >= ?', min_price).order(:name).limit(1).first
    if min_price > max_price
      error = "max price cannot be less than 0"
      failed_response(error)
    else
      successful_response(item)
    end
  end

  def find_max_price(max_price)
    max_price = params[:max_price].to_f
    item = Item.where('unit_price <= ?', max_price ).order(:name).limit(1).first
    if max_price < 0
      error = "max price cannot be less than 0"
      failed_response(error)
    else
      successful_response(item)
    end
  end

  def find_min_price(min_price)
    min_price = params[:min_price].to_f
    item = Item.where('unit_price >= ?', min_price).order(:name).limit(1).first
    if min_price < 0
      error = "min price cannot less than 0"
      failed_response(error)
    else
      successful_response(item)
    end
  end
end
