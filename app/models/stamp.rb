class Stamp < ApplicationRecord
  belongs_to :label
  belongs_to :creator
  belongs_to :stampable, polymorphic: true
end
