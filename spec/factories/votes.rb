FactoryBot.define do
  factory :upvote, class: :Vote do
    stamp
    user
    type :upvote
  end

  factory :downvote, class: :Vote do
    stamp
    user

    type :downvote
  end
end
