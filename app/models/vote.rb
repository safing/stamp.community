class Vote < ApplicationRecord
  belongs_to :stamp
  belongs_to :user
end
