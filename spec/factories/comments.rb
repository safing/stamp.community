FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.paragraph }

    association :user
    association :commentable, factory: :label_stamp
  end
end
