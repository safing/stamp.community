FactoryBot.define do
  factory :licence do
    name { Faker::Name.name }
    description { Faker::Matz.quote }
  end
end
