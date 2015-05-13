require 'ostruct'

class AnonymousFeedbackPresenter < SimpleDelegator
  attr_reader :current_page, :total_pages, :limit_value

  def initialize(api_response)
    # actually delegate to the API response's `results` array
    super(present_results(api_response["results"]))

    @api_response = api_response["results"]
    @current_page = api_response["current_page"]
    @total_pages = api_response["pages"]
    @limit_value = api_response["page_size"]
  end

  def to_json
    @api_response
  end

private
  def present_results(results)
    results.map { |entry| OpenStruct.new(entry) }
  end
end
