class Label < ApplicationRecord
  belongs_to :parent, class_name: 'Label'
  has_many :stamps
end
