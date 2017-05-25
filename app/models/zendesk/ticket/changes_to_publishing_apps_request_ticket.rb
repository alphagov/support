require 'zendesk/zendesk_ticket'
require 'zendesk/labelled_snippet'

module Zendesk
  module Ticket
    class ChangesToPublishingAppsRequestTicket < ZendeskTicket
      attr_reader :time_constraint

      def subject
        (@request.title.nil? or @request.title.empty?) ? "" : "#{@request.title}"
      end

      def tags
        super + ["new_feature_request"]
      end

      protected
      def comment_snippets
        [
          LabelledSnippet.new(on: @request,                 field: :user_need),
          LabelledSnippet.new(on: @request,                 field: :feature_evidence),
        ]
      end
    end
  end
end
