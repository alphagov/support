module Zendesk
  module Ticket
    class EuExitBusinessReadinessTicket < Zendesk::ZendeskTicket
      def subject
        "EU Exit Business Readiness - #{@request.url}"
      end

      def tags
        super + %w[business_readiness dapper govt_form eu_exit]
      end

    protected

      def comment_snippets
        fields.map do |field|
          Zendesk::LabelledSnippet.new(on: @request, field: field)
        end
      end

      def fields
        %w(
          type url explanation sector business_activity employing_eu_citizens
          personal_data intellectual_property funding_schemes
          public_sector_procurement
        )
      end
    end
  end
end
