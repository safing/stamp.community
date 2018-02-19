FactoryBot.define do
  factory :vote do
    association :votable, factory: :stamp
    accept { Faker::Boolean.boolean }
    user
  end
end
