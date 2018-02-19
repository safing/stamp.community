FactoryBot.define do
  factory :domain do
    name { Faker::Internet.domain_name }
    creator { create(:user) }
  end
end
