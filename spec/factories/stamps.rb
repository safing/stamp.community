FactoryBot.define do
  factory :stamp do
    creator { build(:user) }
    stampable { build(:domain) }

    trait :accepted do
      state { :accepted }
    end

    trait :with_votes do
      transient do
        activities { false }
      end

      after(:create) do |stamp, evaluator|
        stamp.votes << FactoryBot.build_list(:upvote, 2, votable: stamp)
        stamp.votes << FactoryBot.build_list(:downvote, 2, votable: stamp)
        stamp.save

        if evaluator.activities
          stamp.votes.each do |vote|
            FactoryBot.create(:vote_activity, vote: vote)
          end
        end
      end
    end

    trait :with_comments do
      after(:create) do |stamp, _|
        stamp.comments << FactoryBot.build(:comment, commentable: stamp, user_id: stamp.user_id)
        stamp.comments << FactoryBot.build_list(:comment, 2, commentable: stamp)
        stamp.save
      end
    end

    trait :with_creation_activity do
      after(:create) do |stamp, _|
        stamp.activities << FactoryBot.create(:stamp_activity, trackable: stamp)
      end
    end

    trait :with_accept_activity do
      after(:create) do |stamp, _|
        stamp.activities << FactoryBot.create(:transition_activity, trackable: stamp)
      end
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
