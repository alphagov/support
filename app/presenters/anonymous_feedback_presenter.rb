require 'long_form_contact_presenter'
require 'problem_report_presenter'
require 'service_feedback_presenter'

class AnonymousFeedbackPresenter < SimpleDelegator
  attr_reader :current_page, :total_pages, :limit_value

  def initialize(api_response)
    # actually delegate to the API response's `results` array
    super(present_results(api_response["results"]))

    @current_page = api_response["current_page"]
    @total_pages = api_response["pages"]
    @limit_value = api_response["page_size"]
  end

private
  def present_results(results)
    results.map { |anonymous_contact|
      present(anonymous_contact)
    }
  end

  def present(anonymous_contact)
    presenter_for(anonymous_contact).new(anonymous_contact)
  end

  def presenter_for(anonymous_contact)
    case anonymous_contact["type"]
    when "long_form_contact"
      LongFormContactPresenter
    when "problem_report"
      ProblemReportPresenter
    when "service_feedback"
      ServiceFeedbackPresenter
    end
  end
end
