FactoryBot.define do
  factory :data_stamp do
    upvote_count 0
    downvote_count 0
    creator_id { create(:user).id }
    association :stampable, factory: :domain
  end
end
