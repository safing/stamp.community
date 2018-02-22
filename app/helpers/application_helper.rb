module ApplicationHelper
  def current_day
    Time.current.utc.to_date
  end

  def current_day_range
    current_day.beginning_of_day..current_day.end_of_day
  end
end
