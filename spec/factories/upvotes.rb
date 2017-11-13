FactoryBot.define do
  factory :upvote do
    association :votable, factory: :stamp
    user
  end
end
