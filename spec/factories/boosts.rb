FactoryBot.define do
  factory :boost do
    association :user
    association :activity, factory: :domain_activity
    reputation { Faker::Number.between(-10, 20) }
  end
end
