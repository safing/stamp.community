class Label < ApplicationRecord
  belongs_to :licence
  belongs_to :parent, class_name: 'Label', optional: true

  has_many :stamps

  # TODO
  def top_contributors
    User.joins(:stamps)
        .select('stamps.creator_id, COUNT(stamps.creator_id)')
        .where(stamps: { label_id: id })
        .group('stamps.creator_id')
        .order('COUNT(stamps.creator_id)')
        .first(5)
  end
end
