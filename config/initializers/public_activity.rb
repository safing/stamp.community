PublicActivity::Activity.class_eval do
  has_one :boost, foreign_key: :cause_id # an activity can only cause one boost, iE stamp.create
  has_many :boosts, foreign_key: :trigger_id # a trigger can cause multiple boosts, iE stamp.accept

  validates :key, presence: true, inclusion: { in: Activity::KEYS }
end
