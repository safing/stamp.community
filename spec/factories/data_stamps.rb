FactoryBot.define do
  factory :data_stamp do
    upvote_count 0
    downvote_count 0
    creator { build(:user) }
    stampable { build(:domain, creator: creator) }
  end
end
