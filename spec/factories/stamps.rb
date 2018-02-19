FactoryBot.define do
  factory :stamp do
    label
    percentage { Faker::Number.between(1, 100) }
    association :creator, factory: :user
    association :stampable, factory: :domain
  end
end
