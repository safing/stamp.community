class InternalStamp < ApplicationRecord
  belongs_to :label
  belongs_to :creator
end
