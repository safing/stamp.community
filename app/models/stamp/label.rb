class Stamp::Label < Stamp
  jsonb_accessor :data, label_id: [:integer]
  jsonb_accessor :data, percentage: [:integer]

  belongs_to :label, class_name: '::Label'

  validates_presence_of :label_id, :percentage
  validates :stampable_type, inclusion: { in: ['Domain'] }

  validate :complies_to_label_config
  validate :initial_stamp_cannot_be_0

  def domain
    stampable
  end

  def initial_stamp_cannot_be_0
    return true if percentage != 0
    return true if peers.accepted.present?

    errors.add(:percentage, 'can only be set to 0 if an accepted sibling stamp is > 0')
  end

  def complies_to_label_config
    if label.binary
      message = 'must equal 0 or 100, since the referenced label is binary'
      errors.add(:percentage, message) unless [0, 100].include?(percentage)
    else
      message = "must be set to steps of #{label.steps}, as defined by the referenced label"
      errors.add(:percentage, message) if percentage % label.steps != 0
    end
  end

  # siblings == stamps with the same stampable
  # peers == stamps with the same stampable & with the same label
  def peers
    siblings.jsonb_where(:data, label_id: label_id)
  end

  def peers?
    peers.count.positive?
  end

  # https://stackoverflow.com/a/9463495/2235594
  # might override stuff, a better approach might be:
  # https://gist.github.com/sj26/5843855
  def self.model_name
    base_class.model_name
  end
end
