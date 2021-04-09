module Findable
  def success(item)
   item ? (render json: ItemSerializer.new(item)) : (render json: {data: {}})
  end

  def failure(error)
    render json: { error: error}, status: :bad_request
  end

  def search_by_name(name)
    search_term = name.downcase
    item = Item.find_item_by_name_fragment(search_term)
    success(item)
  end

  def find_min_and_max_price(min_price, max_price)
    item = Item.find_by_min_and_max_price(min_price, max_price)
    error = "max price cannot be less than 0"
    min_price > max_price ? failure(error) : success(item)
  end

  def find_max_price(max_price)
    max_price = params[:max_price].to_f
    item = Item.find_by_max_price(max_price)
    error = "max price cannot be less than 0"
    max_price < 0 ? failure(error) : success(item)
  end

  def find_min_price(min_price)
    min_price = params[:min_price].to_f
    item = Item.find_by_min_price(min_price)
    error = "min price cannot less than 0"
    min_price < 0 ? failure(error) : success(item)
  end
end
