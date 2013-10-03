require 'zendesk_ticket'
require 'labelled_snippet'

module Zendesk
  module Ticket
    class ProblemReportTicket < ZendeskTicket
      def subject
        @request.url.nil? ? "Unknown page" : URI.parse(@request.url).path
      end

      def tags
        ["anonymous_feedback", "public_form", "report_a_problem"] + source_tag_if_needed + govuk_referrer_tag_if_needed + page_owner_tag_if_needed
      end

      def comment
        [:url, :what_doing, :what_wrong, :user_agent, :referrer, :javascript_enabled].map do |attribute|
          "#{attribute}: #{value_of(attribute)}"
        end.join("\n")
      end

      protected
      def source_tag_if_needed
        @request.source.nil? ? [] : [ @request.source ]
      end

      def page_owner_tag_if_needed
        @request.page_owner.nil? ? [] : ["page_owner/#{@request.page_owner}"]
      end

      def govuk_referrer_tag_if_needed
        @request.referrer_url_on_gov_uk? ? ["govuk_referrer"] : []
      end

      def value_of(attribute)
        @request.send(attribute.to_sym) || "unknown"
      end
    end
  end
end
