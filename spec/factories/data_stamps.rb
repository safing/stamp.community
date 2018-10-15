FactoryBot.define do
  factory :data_stamp do
    upvote_count 0
    downvote_count 0
    user { build(:user) }
    stampable { build(:domain, user: user) }
  end
end
