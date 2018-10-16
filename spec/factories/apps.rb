require 'securerandom'

FactoryBot.define do
  factory :app do
    description { Faker::Lorem.paragraph }
    name { Faker::App.name }
    link { Faker::Internet.url }
    user
    uuid { SecureRandom.uuid }
  end
end
