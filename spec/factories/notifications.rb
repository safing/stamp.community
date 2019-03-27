FactoryBot.define do
  factory :notification do
    association :actor, factory: :user
    association :recipient, factory: :user

    association :activity, factory: :transition_activity
    association :reference, factory: :flag_stamp

    read { Faker::Boolean.boolean }

    trait :system_actor do
      actor { System.new }
    end
  end
end
