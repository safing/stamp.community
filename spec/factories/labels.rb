FactoryBot.define do
  factory :label do
    name { Faker::Internet.domain_word }
    description { Faker::WorldOfWarcraft.quote }

    trait :with_stamps do
      stamps { build_list :stamp, 3 }
    end
  end
end
