FactoryBot.define do
  factory :prefecture do
    prefecture_name { Faker::Lorem.characters(number: 5) }
  end
end
