FactoryBot.define do
  factory :item do
    name { "Item" }
    description { "Description" }
    unit_price { "9.99" }
    merchant
  end
end
