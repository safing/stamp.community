class Stamp::Label < Stamp
  jsonb_accessor :data, label_id: [:integer]
  jsonb_accessor :data, percentage: [:integer]

  belongs_to :label, class_name: '::Label'

  validates_presence_of :label_id, :percentage, :comments
  validates :stampable_type, inclusion: { in: ['Domain'] }

  validate :complies_to_label_config
  validate :initial_stamp_cannot_be_0

  def domain
    stampable
  end

  def stampable_name
    domain.name
  end

  def initial_stamp_cannot_be_0
    return true if percentage != 0
    return true if siblings.accepted.present?

    errors.add(:percentage, 'can only be set to 0 if an accepted sibling stamp is > 0')
  end

  def complies_to_label_config
    message = if label.binary
                return true if [0, 100].include?(percentage)
                'must equal 0 or 100, since the referenced label is binary'
              else
                return true if (percentage % label.steps).zero?
                "must be set to steps of #{label.steps}, as defined by the referenced label"
              end
    errors.add(:percentage, message)
  end

  #    peers = stamps with the same stampable
  # siblings = stamps with the same stampable & with the same label
  def siblings
    peers.jsonb_where(:data, label_id: label_id)
  end

  def siblings?
    siblings.count.positive?
  end
end
