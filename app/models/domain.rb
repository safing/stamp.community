class Domain < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :parent, class_name: 'Domain'
  has_many :children, class_name: 'Domain', foreign_key: 'parent_id'
  has_many :stamps, as: :stampable

  def parent_name
    parent.name if parent_id.present?
  end
end
