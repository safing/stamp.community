FactoryBot.define do
  factory :stamp do
    upvote_count 0
    downvote_count 0
    label
    creator_id { create(:user).id }
    association :stampable, factory: :domain
  end
end
