FactoryBot.define do
  factory :vote do
    accept { Faker::Boolean.boolean(0.7) }
    power { Faker::Number.number(1) }

    association :user
    association :votable, factory: :label_stamp
  end

  factory :upvote, class: Vote do
    accept { true }
    power { Faker::Number.number(1) }

    association :user
    association :votable, factory: :label_stamp
  end

  factory :downvote, class: Vote do
    accept { false }
    power { Faker::Number.number(1) }

    association :user
    association :votable, factory: :label_stamp
  end
end
