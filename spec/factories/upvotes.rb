FactoryBot.define do
  factory :upvote do
    association :voteable, factory: :stamp
    user
  end
end
