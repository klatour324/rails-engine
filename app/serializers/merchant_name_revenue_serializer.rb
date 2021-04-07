class MerchantNameRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name
  attributes :revenue do |merchant|
    merchant.revenue.to_f
  end
end
