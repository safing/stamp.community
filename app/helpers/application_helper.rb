module ApplicationHelper
  def current_day
    Time.current.utc.to_date
  end

  def current_day_range
    current_day.beginning_of_day..current_day.end_of_day
  end

  def semantic_class_for(flash_type)
    {
      success: 'success',
      error: 'error',
      alert: 'warning',
      notice: 'info'
    }[flash_type.to_sym] || flash_type.to_s
  end

  # rubocop:disable CyclomaticComplexity (7/6 if statements? alltough I only count 6)
  # TODO: probably should unit test this, currently tested via views/stamps/show
  def caret_class_for(stamp, type)
    return 'grey' if return_grey?(stamp, type)

    case stamp.state.to_sym
    when :archived, :disputed, :in_progress then 'purple'
    when :accepted then type == 'upvote' ? 'green' : 'red'
    when :denied then type == 'upvote' ? 'red' : 'green'
    end
  end
  # rubocop:enable CyclomaticComplexity

  def class_for(state)
    case state.to_sym
    when :accepted then 'green'
    when :archived then 'grey'
    when :denied then 'red'
    when :disputed then 'grey'
    when :in_progress then 'purple'
    end
  end

  private

  def return_grey?(stamp, type)
    current_user.blank? ||
      stamp.vote_of(current_user).blank? ||
      stamp.vote_of(current_user).vote_type != type
  end
end
