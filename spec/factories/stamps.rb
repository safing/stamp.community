FactoryBot.define do
  factory :stamp do
    label
    percentage { Faker::Number.between(1, 100) }
    association :creator, factory: :user
    association :stampable, factory: :domain

    trait :with_upvotes do
      votes { build_list :upvote, 2 }
    end

    trait :with_downvotes do
      votes { build_list :downvote, 2 }
    end
  end
end
