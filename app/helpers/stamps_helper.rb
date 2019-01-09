module StampsHelper
  def detail_in_words(stamp)
    if stamp.in_progress?
      distance_of_time_in_words(Time.now, stamp.conclusion_at) + ' left'
    else
      time_ago_in_words(stamp.concluded_at) + ' ago'
    end
  end

  def color_for(state)
    case state.to_sym
    when :accepted then 'green'
    when :archived then 'grey'
    when :denied then 'red'
    when :disputed then 'grey'
    when :in_progress then 'purple'
    end
  end
end
