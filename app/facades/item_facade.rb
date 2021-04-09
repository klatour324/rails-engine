# class ItemFacade
  # def self.success(item)
  #  item ? (render json: ItemSerializer.new(item)) : (render json: {data: {}})
  # end
#
  # def self.failure(error)
  #   render json: { error: error}, status: :bad_request
  # end
#
  # def self.search_by_name(name)
  #   search_term = name.downcase
  #   item = Item.find_item_by_name_fragment(search_term)
  # end
#
  # def self.find_min_and_max_price(min_price, max_price)
  #   item = Item.find_by_min_and_max_price(min_price, max_price)
  #   if min_price > max_price
  #     error = "max price cannot be less than 0"
  #     self.failure(error)
  #   else
  #     self.success(item)
  #   end
#
#   def self.find_max_price(max_price)
#     max_price = params[:max_price].to_f
#     item = Item.find_by_max_price(max_price)
#     if max_price < 0
#       error = "max price cannot be less than 0"
#       failure(error)
#     else
#       success(item)
#     end
#   end
#
#   def self.find_min_price(min_price)
#     min_price = params[:min_price].to_f
#     item = Item.find_by_min_price(min_price)
#     if min_price < 0
#       error = "min price cannot less than 0"
#       failure(error)
#     else
#       success(item)
#     end
#   end
# end
