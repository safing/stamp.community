class DataStamp < ApplicationRecord
  include StampState

  belongs_to :label
  belongs_to :creator, class_name: 'User'
  belongs_to :stampable, polymorphic: true
end
