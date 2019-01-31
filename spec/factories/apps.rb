require 'securerandom'

FactoryBot.define do
  factory :app do
    description { Faker::Lorem.paragraph }
    name { Faker::App.name }
    link { Faker::Internet.domain_name }
    uuid { SecureRandom.uuid }

    linux { true }

    trait :linux do
      linux { true }
    end

    trait :macos do
      macos { true }
    end

    trait :windows do
      windows { true }
    end
  end
end
