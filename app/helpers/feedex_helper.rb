module FeedexHelper
  def total_responses_header(total_count:, from:, to:, results_limited:, scopes:)

    response_total = get_response_total(total_count, results_limited, scopes)

    if from.present? && to.present?
      "#{response_total} between #{from} and #{to}"
    elsif from.present?
      "#{response_total} since #{from}"
    elsif to.present?
      "#{response_total} before #{to}"
    elsif total_count && total_count > 1 && !results_limited
      "All #{response_total}"
    elsif scopes.done_page?
      "All responses"
    else
      response_total
    end
  end

  def get_response_total(total_count, results_limited, scopes)
    return "Responses" if scopes.done_page?
    response_total = pluralize(number_with_delimiter(total_count), "response")
    response_total = "Over #{response_total}" if results_limited
    response_total
  end
end
