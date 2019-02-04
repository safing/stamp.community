class Boost < ApplicationRecord
  belongs_to :user
  belongs_to :activity, class_name: 'PublicActivity::Activity', foreign_key: 'activity_id'

  validates_presence_of %i[activity reputation user]
end
