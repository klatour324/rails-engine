class MerchantItemsSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :unit_price, :merchant_id

  attribute :unit_price do |object|
    object.unit_price.to_f
  end
end
