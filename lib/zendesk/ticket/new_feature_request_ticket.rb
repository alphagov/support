require 'zendesk_ticket'
require 'labelled_snippet'

module Zendesk
  module Ticket
    class NewFeatureRequestTicket < ZendeskTicket
      attr_reader :time_constraint

      def subject
        @request.inside_government_related? ? "New Feature Request" : "New Need Request"
      end

      def tags
        specific_tag = @request.inside_government_related? ? ["new_feature_request"] : ["new_need_request"]
        super + specific_tag + inside_government_tag_if_needed
      end

      protected
      def comment_snippets
        [ 
          LabelledSnippet.new(on: @request,                 field: :formatted_request_context,
                                                           label: "Which part of GOV.UK is this about?"),
          LabelledSnippet.new(on: @request,                 field: :user_need),
          LabelledSnippet.new(on: @request,                 field: :url_of_example),
          LabelledSnippet.new(on: @request.time_constraint, field: :time_constraint_reason)
        ]
      end
    end
  end
end
