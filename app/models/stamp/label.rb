class Stamp::Label < Stamp
  jsonb_accessor :data, label_id: [:integer]
  jsonb_accessor :data, percentage: [:integer]

  belongs_to :label, class_name: '::Label'

  validates_presence_of :label_id, :percentage
  validates :stampable_type, inclusion: { in: ['Domain'] }

  def domain
    stampable
  end

  # https://stackoverflow.com/a/9463495/2235594
  # might override stuff, a better approach might be:
  # https://gist.github.com/sj26/5843855
  def self.model_name
    base_class.model_name
  end
end
