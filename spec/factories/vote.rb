FactoryBot.define do
  factory :vote do
    accept { Faker::Boolean.boolean(0.7) }

    association :user
    association :votable, factory: :stamp
  end

  factory :upvote, class: Vote do
    accept true

    association :user
    association :votable, factory: :stamp
  end

  factory :downvote, class: Vote do
    accept false

    association :user
    association :votable, factory: :stamp
  end
end
