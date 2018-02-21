class Stamp < ApplicationRecord
  include Votable
  include Votable::State

  validates :percentage, numericality: { greater_than: 0, less_than_or_equal_to: 100 }

  belongs_to :label
end
