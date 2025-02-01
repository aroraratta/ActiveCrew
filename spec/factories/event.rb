FactoryBot.define do
  factory :event do
    event_title { Faker::Lorem.characters(number: 20) }
    event_place { Faker::Lorem.characters(number: 20) }
    event_memo { Faker::Lorem.characters(number: 20) }
    circle
  end
end
