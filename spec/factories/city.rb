FactoryBot.define do
  factory :city do
    city_name { Faker::Lorem.characters(number: 5) }
    prefecture
  end
end
