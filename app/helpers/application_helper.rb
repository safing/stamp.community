module ApplicationHelper
  def current_day
    Time.current.utc.to_date
  end

  def current_day_range
    current_day.beginning_of_day..current_day.end_of_day
  end

  def semantic_class_for(flash_type)
    {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-primary'
    }[flash_type.to_sym] || flash_type.to_s
  end
end
