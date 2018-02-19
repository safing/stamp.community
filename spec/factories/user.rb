FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Internet.user_name }
    password { Faker::Internet.password(12, 30) }
    reputation { Faker::Number.between(-10, 20_000) }

    trait :confirmed do
      confirmed_at { 2.minutes.ago }
      confirmation_sent_at { 5.minutes.ago }
    end
  end
end
