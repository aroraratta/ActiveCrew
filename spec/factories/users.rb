FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Lorem.characters(number: 10) }
    introduction { Faker::Lorem.characters(number: 20) }
    password { "password" }
    password_confirmation { "password" }
    
    # after(:build) do |user|
    #   user.user_image.attach(io: File.open("spec/images/logo.png"), filename: "logo.png")
    # end
  end
end
