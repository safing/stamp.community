PublicActivity::Activity.class_eval do
  has_one :boost, foreign_key: :cause_id # an activity can only cause one boost, iE stamp.create
  has_many :boosts, foreign_key: :trigger_id # a trigger can cause multiple boosts, iE stamp.accept

  validates :key, presence: true, inclusion: { in: Activity::KEYS }

  # key can only have one dot (.) as defined in Activity::KEYS
  def config_key
    key.sub('.', '_').to_sym
  end

  # if it is not set yet, it will fetch and set the data
  # second call already retrieves the cache
  # => adding caches in Activity::CACHE_CONFIG is no big deal & performant
  def cache(cache_key)
    value = parameters[cache_key.to_s]

    return value if value.present? || !cache_key_set?(cache_key)

    set_cache!
    cache(cache_key)
  end

  def cache_key_set?(cache_key)
    Activity::CACHE_CONFIG[config_key][cache_key.to_sym].present?
  end

  # if you want to reload all of the caches, use PublicActivity::Activity.all.each(&:set_cache!)
  # though it is still performant to just get the caches whenever needed
  def set_cache!
    Activity::CACHE_CONFIG[config_key]&.each do |cache_key, retrievers|
      parameters[cache_key.to_s] = fetch_value(retrievers)
    end

    save if changed?
  end

  def fetch_value(retrievers)
    retrievers.split('.').inject(self) do |cache_value, retriever|
      cache_value.send(retriever)
    end
  end
end
