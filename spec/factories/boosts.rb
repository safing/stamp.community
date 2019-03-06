FactoryBot.define do
  factory :boost do
    association :user
    association :trigger, factory: :signup_activity
    cause { FactoryBot.create(:signup_activity, owner: user) }
    reputation { Faker::Number.between(-10, 20) }
  end
end
