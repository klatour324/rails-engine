class UnshippedInvoiceSerializer
  include FastJsonapi::ObjectSerializer
  attributes :potential_revenue

  attribute :potential_revenue do |object|
    object.potential_revenue.to_f
  end
end
