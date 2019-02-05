class Boost < ApplicationRecord
  belongs_to :user
  belongs_to :activity, class_name: 'PublicActivity::Activity', foreign_key: 'activity_id'

  validates_presence_of %i[activity reputation user]
  validates :reputation, numericality: { other_than: 0 }

  # https://github.com/magnusvk/counter_culture#totaling-instead-of-counting
  counter_culture :user, column_name: 'reputation', delta_column: 'reputation'
end
