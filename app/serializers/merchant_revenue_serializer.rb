class MerchantRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :revenue do |merchant|
    merchant.total_revenue
  end
end
