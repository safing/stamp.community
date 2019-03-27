FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.paragraph }

    association :user
    association :commentable, factory: :label_stamp
  end

  # meaning: the comment & commentable were created by the same user 
  factory :initial_comment, parent: :comment do
    commentable { create(:label_stamp, creator: user) }
  end
end
