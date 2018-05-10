FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Internet.user_name }
    password { Faker::Internet.password(12, 30) }
    reputation { Faker::Number.between(-10, 20_000) }

    confirmed_at { 2.minutes.ago }
    confirmation_sent_at { 5.minutes.ago }

    trait :unconfirmed do
      confirmed_at nil
      confirmation_sent_at nil
    end
  end
end
