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
      repository = Repositories::SupportApiRepository.new(session[:support_app_reference])
      submitted_data = repository.read

      {
        title: submitted_data["type"].titleize.to_s,
        details: request_details(submitted_data),
        requester_attributes: {
          collaborator_emails: submitted_data["cc_email"],
        },
        time_constraint_attributes: {
          needed_by_day: "1",
          needed_by_month: "1",
          needed_by_year: "2027",
          time_constraint_reason: "This is a test",
        },
      }
    end

    def request_details(submitted_data)
      details = []
      submitted_data.each do |key, value|
        details << "[#{key.titleize}]\n"
        details << "#{value}\n"
      end
      details.join("\n")
    end
  end
end
