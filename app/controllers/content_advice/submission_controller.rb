# frozen_string_literal: true

module ContentAdvice
  class SubmissionController < RequestsController
    def build_request
      @request = Support::Requests::ContentAdviceRequest.new(request_data)
    end

    def zendesk_ticket_class
      Zendesk::Ticket::ContentAdviceRequestTicket
    end

    def request_data
      {
        title: session[:content_advice]["type"].titleize.to_s,
        details: request_details,
        requester_attributes: {
          collaborator_emails: session[:content_advice]["cc_email"],
        },
        time_constraint_attributes: {
          needed_by_day: "1",
          needed_by_month: "1",
          needed_by_year: "2027",
          time_constraint_reason: "This is a test",
        },
      }
    end

    def request_details
      details = []
      session[:content_advice].each do |key, value|
        details << "[#{key.titleize}]\n"
        details << "#{value}\n"
      end
      details.join("\n")
    end
  end
end
