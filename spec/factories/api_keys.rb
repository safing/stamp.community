FactoryBot.define do
  factory :api_key do
    token { Faker::Crypto.md5 }
    user
  end
end
