FactoryBot.define do
  factory :label do
    name { Faker::Internet.domain_word }
  end
end
