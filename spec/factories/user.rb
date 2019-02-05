FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Internet.user_name }
    password { Faker::Internet.password(12, 30) }
    reputation { Faker::Number.between(-10, 20_000) }

    confirmed_at { 2.minutes.ago }
    confirmation_sent_at { 5.minutes.ago }

    trait :unconfirmed do
      confirmed_at { nil }
      confirmation_sent_at { nil }
    end

    trait :with_signup_activity do
      after(:create) do |user|
        activity = FactoryBot.create(:signup_activity, owner: user, trackable: user)
        FactoryBot.create(:boost, reputation: 1, user: user, activity: activity)
      end
    end
  end

  factory :moderator, parent: :user do
    role { :moderator }
  end

  factory :admin, parent: :user do
    role { :admin }
  end
end
