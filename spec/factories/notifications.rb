FactoryBot.define do
  factory :notification do
    association :actor, factory: :user
    association :recipient, factory: :user

    association :activity, factory: :domain_activity
    association :reference, factory: :domain

    read { Faker::Boolean.boolean }

    trait :system_actor do
      actor { System.new }
    end
  end
end
