module DateFilterHelper

  def date_filtered?
    @from_date.present? or @to_date.present?
  end

  def attempted_to_filter?
    params[:from].present? or params[:to].present?
  end

  def invalid_filter?
    attempted_to_filter? && !date_filtered?
  end

  def total_responses_header(total_count, from_date, to_date)
    from = from_date.to_s(:govuk_date_short) if from_date
    to = to_date.to_s(:govuk_date_short) if to_date

    response_total = pluralize(number_with_delimiter(total_count), 'response')

    if from.present? and to.present?
      "#{response_total} between #{from} and #{to}"
    elsif from.present?
      "#{response_total} since #{from}"
    elsif to.present?
      "#{response_total} before #{to}"
    elsif total_count && total_count > 1
      "All #{response_total}"
    else
      response_total
    end
  end

  def date_range_track_action(from_date=nil, to_date=nil)
    if from_date && to_date
      "filtering between two dates"
    elsif from_date
      "filtering everything since date"
    elsif to_date
      "filtering everying before date"
    else
      "no filtering"
    end
  end

  def date_range_track_label(from_date, to_date)
    from_date ||= Date.new(1970,1,1)
    to_date ||= Date.current
    date_range = distance_of_time_in_words(from_date, to_date)
    date_ago = time_ago_in_words(to_date)
    date_ago = 0 if to_date.at_middle_of_day() == Date.current.at_middle_of_day()
    return "selected date range: #{date_range}, time between search and 'to' date provided: #{date_ago}"
  end
end
