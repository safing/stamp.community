FactoryBot.define do
  factory :vote do
    association :votable, factory: :stamp
    user
  end
end
