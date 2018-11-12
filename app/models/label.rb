class Label < ApplicationRecord
  belongs_to :licence
  belongs_to :parent, class_name: 'Label', optional: true

  has_many :children, class_name: 'Label', foreign_key: :parent_id

  validates_presence_of %i[description licence name]

  jsonb_accessor :config, binary: [:boolean, default: false], steps: [:integer, default: 5]

  validates :steps, inclusion: { in: [nil, 1, 5, 10] }

  # TODO
  def top_contributors
    User.joins(:stamps)
        .select('stamps.user_id, COUNT(stamps.user_id)')
        .where("stamps.data @> ('{\"label_id\": ?}')::jsonb", id)
        .group('stamps.user_id')
        .order('COUNT(stamps.user_id) DESC')
        .limit(5)
  end

  def stamps
    Stamp::Label.all.jsonb_where(:data, label_id: id)
  end

  def stamps_in_progress
    stamps.in_progress.data_order(percentage: :desc).limit(5)
  end
end
