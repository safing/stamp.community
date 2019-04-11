class Notification < ApplicationRecord
  belongs_to :activity, class_name: 'PublicActivity::Activity'
  belongs_to :actor, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  belongs_to :reference, polymorphic: true

  validates_presence_of %i[activity actor recipient reference]

  scope :unread, -> { where(read: false) }

  def actor
    actor_id == -1 ? System.new : super
  end
end
