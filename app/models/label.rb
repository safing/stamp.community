class Label < ApplicationRecord
  belongs_to :licence
  belongs_to :parent, class_name: 'Label', optional: true

  has_many :stamps
end
