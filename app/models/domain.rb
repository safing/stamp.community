class Domain < ApplicationRecord
  self.primary_key = 'name'

  # rubocop:disable LineLength
  # got the regex from https://stackoverflow.com/a/26987741/2235594
  NAME_REGEX = /(((?!\-))(xn\-\-)?[a-z0-9\-_]{0,61}[a-z0-9]{1,1}\.)*(xn\-\-)?([a-z0-9\-]{1,61}|[a-z0-9\-]{1,30}\.[a-z]{2,})/
  # rubocop:enable LineLength

  belongs_to :creator, class_name: 'User'
  belongs_to :parent, class_name: 'Domain'
  has_many :children, class_name: 'Domain', foreign_key: 'parent_id'
  has_many :stamps, as: :stampable

  validates :name, format: { with: NAME_REGEX, message: 'invalid domain name' }

  def parent_name
    parent.name if parent_id.present?
  end
end
