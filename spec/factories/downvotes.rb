FactoryBot.define do
  factory :downvote do
    association :voteable, factory: :stamp
    user
  end
end
