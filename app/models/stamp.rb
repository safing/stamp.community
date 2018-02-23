class Stamp < ApplicationRecord
  include Votable
  include Votable::State

  validates :percentage, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
  validates_presence_of :creator, :label, :percentage, :stampable, :state

  belongs_to :label
end
