FactoryBot.define do
  factory :domain do
    name { Faker::Internet.domain_name }
    creator { create(:user) }

    trait :with_stamps do
      stamps { build_list :stamp, 3 }
    end
  end
end
