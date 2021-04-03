FactoryBot.define do
  factory :item do
    name { Faker::Appliance.brand }
    description { Faker::Fantasy::Tolkien.poem  }
    sequence :unit_price do |n|
      n + 10
    end
    merchant
  end
end
