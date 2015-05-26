require 'ostruct'

class OrganisationSummaryPresenter < SimpleDelegator
  def initialize(api_response)
    # actually delegate to the API response's `anonymous_feedback_counts` array
    super(present_results(api_response["anonymous_feedback_counts"]))
  end

private
  def present_results(results)
    results.map { |entry| OpenStruct.new(entry) }
  end
end
