class Domain < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :parent, class_name: 'Domain'
  has_many :children, class_name: 'Domain', foreign_key: 'parent_id'
end
