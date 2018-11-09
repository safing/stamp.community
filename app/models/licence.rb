class Licence < ApplicationRecord
  has_many :labels

  validates_presence_of %i[description name]
end
