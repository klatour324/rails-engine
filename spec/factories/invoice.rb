FactoryBot.define do
  factory :invoice do
    status { "shipped" }
    customer
    merhant
  end
end
