FactoryBot.define do
  factory :stamp do
    upvote_count 0
    downvote_count 0
    label
    percentage { Faker::Number.between(1, 100) }
    association :creator, factory: :user
    association :stampable, factory: :domain
  end
end
