class Stamp < ApplicationRecord
  belongs_to :label
  belongs_to :creator, class_name: 'User'
  belongs_to :stampable, polymorphic: true
end
