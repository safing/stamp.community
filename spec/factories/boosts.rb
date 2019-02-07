FactoryBot.define do
  factory :boost do
    association :user
    association :cause, factory: :signup_activity
    association :trigger, factory: :signup_activity
    reputation { Faker::Number.between(-10, 20) }
  end
end
