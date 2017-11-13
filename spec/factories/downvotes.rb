FactoryBot.define do
  factory :downvote do
    association :votable, factory: :stamp
    user
  end
end
