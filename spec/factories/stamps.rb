FactoryBot.define do
  factory :stamp do
    upvote_count 0
    downvote_count 0
    label
    creator_id { create(:user).id }
    stampable_type 'Domain'
    stampable_id { create(:domain).id }
  end
end
