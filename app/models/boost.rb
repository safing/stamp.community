class Boost < ApplicationRecord
  belongs_to :user
  belongs_to :cause, class_name: 'PublicActivity::Activity', foreign_key: :cause_id
  belongs_to :trigger, class_name: 'PublicActivity::Activity', foreign_key: :trigger_id

  validates_presence_of %i[cause reputation trigger user]
  validates :reputation, numericality: { other_than: 0 }

  # https://github.com/magnusvk/counter_culture#totaling-instead-of-counting
  counter_culture :user, column_name: 'reputation', delta_column: 'reputation'
end
