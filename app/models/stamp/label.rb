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

  def initial_stamp_cannot_be_0
    return true if percentage != 0
    return true if peers.accepted.present?

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

  # https://stackoverflow.com/a/9463495/2235594
  # might override stuff, a better approach might be:
  # https://gist.github.com/sj26/5843855
  def self.model_name
    base_class.model_name
  end
end
