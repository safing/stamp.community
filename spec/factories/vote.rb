FactoryBot.define do
  factory :vote do
    accept { Faker::Boolean.boolean(0.7) }

    association :user
    association :votable, factory: :stamp
  end
end
