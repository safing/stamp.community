FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.sentence }

    association :user
    association :commentable, factory: :stamp
  end
end
