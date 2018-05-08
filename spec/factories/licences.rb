FactoryBot.define do
  factory :licence do
    name { Faker::Name.name }
    description { Faker::Matz.quote }

    trait :with_labels do
      labels { build_list(:label, 3) }
    end
  end
end
