FactoryBot.define do
  factory :activity, class: PublicActivity::Activity do
    association :owner, factory: :user
  end

  factory :domain_activity, parent: :activity do
    association :trackable, factory: :domain

    key { 'domain.create' }
  end

  factory :app_activity, parent: :activity do
    association :trackable, factory: :app

    key { 'app.create' }
  end

  factory :signup_activity, parent: :activity do
    association :trackable, factory: :user
    key { 'user.signup' }
  end

  factory :stamp_activity, parent: :activity do
    association :trackable, factory: :flag_stamp
    owner { trackable.creator }
    recipient { trackable.stampable }
    key { 'stamp.create' }
  end

  factory :transition_activity, parent: :activity do
    association :trackable, factory: :label_stamp
    owner_type { 'System' }
    owner_id { -1 }
    key { 'stamp.accept' }
    parameters do
      {
        majority_threshold: 80,
        power_threshold: 5
      }
    end
  end

  factory :vote_activity, parent: :activity do
    transient do
      vote { create(:vote) }
    end

    trackable { vote }
    owner { vote.user }
    recipient { vote.votable }
    key { 'vote.create' }
  end
end
