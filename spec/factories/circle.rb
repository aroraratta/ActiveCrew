FactoryBot.define do
  factory :circle do
    circle_name { Faker::Lorem.characters(number: 20) }
    circle_introduction { Faker::Lorem.characters(number: 20) }
    city
    prefecture
    owner
  end
end
