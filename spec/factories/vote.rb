FactoryBot.define do
  factory :vote do
    association :votable, factory: :stamp
    accept { Faker::Boolean.boolean(0.7) }
    user
  end
end
