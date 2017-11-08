FactoryBot.define do
  factory :domain do
    url { Faker::Internet.domain_name }
    creator { create(:user) }
  end
end
