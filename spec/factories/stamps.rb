FactoryBot.define do
  factory :stamp do
    creator { build(:user) }
    stampable { build(:domain) }

    trait :accepted do
      state { :accepted }
    end

    trait :with_upvotes do
      votes { build_list :upvote, 2 }
    end

    trait :with_downvotes do
      votes { build_list :downvote, 2 }
    end
  end

  factory :label_stamp, class: Stamp::Label, parent: :stamp do
    label
    label_id { label.id }
    comments { build_list(:comment, 1, user: creator, commentable: @instance) }

    percentage { 5 }

    trait :binary do
      percentage { 100 }
    end
  end

  factory :flag_stamp, class: Stamp::Flag, parent: :stamp do
    stampable { build(:app) }
    prompt { true }
  end

  factory :identifier_stamp, class: Stamp::Identifier, parent: :stamp do
  end
end
