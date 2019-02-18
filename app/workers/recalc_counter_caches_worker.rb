class RecalcCounterCachesWorker
  include Sidekiq::Worker

  def perform
    Boost.counter_culture_fix_counts
  end
end
