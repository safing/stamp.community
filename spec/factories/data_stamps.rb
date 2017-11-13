FactoryBot.define do
  factory :data_stamp do
    upvote_count 0
    downvote_count 0
    association :creator, factory: :user
    association :stampable, factory: :domain
  end
end
