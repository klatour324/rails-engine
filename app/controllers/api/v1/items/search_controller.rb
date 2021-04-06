class Api::V1::Items::SearchController < ApplicationController
  def show
    searched_term = params[:name].downcase
    item = Item.find_item_by_name_fragment(searched_term)

    if item
      render json: ItemSerializer.new(item)
    else
      render json: {data: {}}
    end
  end
end
