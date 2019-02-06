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
    key { 'user.signup' }
  end

  factory :transition_activity, parent: :activity do
    key { 'stamp.accept' }
  end
end
