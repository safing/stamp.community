FactoryBot.define do
  factory :label_stamp, class: Stamp::Label do
    creator { build(:user) }
    stampable { build(:domain, user: creator) }
    comments { build_list(:comment, 1, user: creator, commentable: @instance) }

    label
    label_id { label.id }

    percentage 5

    trait :accepted do
      state :accepted
    end

    trait :with_upvotes do
      votes { build_list :upvote, 2 }
    end

    trait :with_downvotes do
      votes { build_list :downvote, 2 }
    end
  end
end
