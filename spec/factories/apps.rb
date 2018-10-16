FactoryBot.define do
  factory :app do
    description { Faker::Lorem.paragraph }
    name { Faker::App.name }
    link { Faker::Internet.url }
    user
  end
end
