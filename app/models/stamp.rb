class Stamp < ApplicationRecord
  include Votable
  include Votable::State

  belongs_to :label
end
