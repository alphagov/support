module Support
  module Requests
    class AnalyticsRequest < Request
      REQUEST_DETAILS_ATTRS = %i[
        google_analytics_request_details
        single_point_of_contact_request_details
        report_request_details
        help_request_details
      ].freeze

      attr_accessor(*REQUEST_DETAILS_ATTRS)

      validate :one_or_more_request_details_present

      def self.label
        "Analytics access, reports and help"
      end

      def self.description
        "Request access to Google Analytics or help with analytics or reports"
      end

      def one_or_more_request_details_present
        request_details = REQUEST_DETAILS_ATTRS.reject do |request_details_attribute|
          send(request_details_attribute).to_s.empty?
        end

        if request_details.empty?
          errors.add(:base, "Please enter details for at least one type of request")
        end
      end
    end
  end
end
