module GuidesHelper
  def voting_period_in_words
    hours = ENVProxy.required_integer('STAMP_CONCLUDE_IN_HOURS')

    period_in_words = "#{hours / 24} days"
    period_in_words += "and #{hours % 24} hours" unless hours % 24 == 0
    period_in_words
  end
end
