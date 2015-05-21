require 'ostruct'

class OrganisationSummaryPresenter < SimpleDelegator
  def initialize(api_response)
    # actually delegate to the API response's `results` array
    super(present_results(api_response["results"]))
  end

private
  def present_results(results)
    sort_results(results).map { |entry| OpenStruct.new(entry) }
  end

  def sort_results(results)
    results.sort_by { |content_item| content_item["path"] }
  end
end
