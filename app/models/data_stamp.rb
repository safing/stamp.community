class DataStamp < ApplicationRecord
  include Votable
  include Votable::State
end
