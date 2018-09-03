FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.paragraph }

    association :user
    association :commentable, factory: :stamp
  end
end
