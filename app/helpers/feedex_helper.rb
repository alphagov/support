module FeedexHelper
  def total_responses_header(total_count:, from:, to:, results_limited:)
    response_total = pluralize(number_with_delimiter(total_count), "response")

    response_total = "Over #{response_total}" if results_limited

    if from.present? && to.present?
      "#{response_total} between #{from} and #{to}"
    elsif from.present?
      "#{response_total} since #{from}"
    elsif to.present?
      "#{response_total} before #{to}"
    elsif total_count && total_count > 1 && !results_limited
      "All #{response_total}"
    else
      response_total
    end
  end
end
