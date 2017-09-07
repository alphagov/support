module Zendesk
  module Ticket
    class ChangesToPublishingAppsRequestTicket < Zendesk::ZendeskTicket
      attr_reader :time_constraint

      def subject
        @request.title.nil? || @request.title.empty? ? "" : @request.title.to_s
      end

      def tags
        super + ["new_feature_request"]
      end

    protected

      def comment_snippets
        [
          Zendesk::LabelledSnippet.new(on: @request,                 field: :user_need),
          Zendesk::LabelledSnippet.new(on: @request,                 field: :feature_evidence),
        ]
      end
    end
  end
end
