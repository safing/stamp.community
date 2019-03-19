FactoryBot.define do
  factory :label do
    name { Faker::Internet.domain_word }
    description { Faker::Games::WorldOfWarcraft.quote }
    licence

    trait :with_stamps do
      after(:create) do |label, _evaluator|
        create_list(:label_stamp, 2, label_id: label.id)
      end
    end
  end
end
