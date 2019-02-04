PublicActivity::Activity.class_eval do
  has_one :boost, foreign_key: :activity_id
end
