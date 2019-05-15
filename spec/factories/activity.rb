FactoryBot.define do
  factory :activity, class: PublicActivity::Activity do
    association :owner, factory: :user
  end
  
  factory :app_activity, parent: :activity do
    association :trackable, factory: :app
    key { 'app.create' }
  end

  factory :comment_activity, parent: :activity do
    association :trackable, factory: :comment
    recipient { trackable.commentable }
    key { 'comment.create' }
  end

  factory :domain_activity, parent: :activity do
    association :trackable, factory: :domain
    key { 'domain.create' }
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
    association :trackable, factory: :flag_stamp
    owner_type { 'System' }
    owner_id { -1 }
    key { 'stamp.accept' }
  end

  factory :user_activity, parent: :activity do
    association :trackable, factory: :user
    owner { trackable }
    recipient { nil }
    key { 'user.create' }
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
