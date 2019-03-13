class Notification < ApplicationRecord
  belongs_to :activity, class_name: 'PublicActivity::Activity'
  belongs_to :actor, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  belongs_to :reference, polymorphic: true
end
