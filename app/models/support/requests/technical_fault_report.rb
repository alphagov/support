require "active_support/core_ext"

module Support
  module Requests
    class TechnicalFaultReport < Request
      attr_accessor :fault_context, :fault_specifics, :actions_leading_to_problem, :what_happened, :what_should_have_happened

      # Zendesk tickets are created with a generic `technical_fault`
      # tag as well as a tag of the form `fault_with_*`, where * is a
      # key from this hash, e.g. `fault_with_collections_publisher`.
      #
      # By default, all `technical_fault` tagged tickets are triaged
      # to `GOV.UK 2nd Line--Alerts and Issues` via this trigger:
      # https://govuk.zendesk.com/admin/objects-rules/rules/triggers/35985647
      #
      # Tickets may be triaged elsewhere if there is another trigger
      # looking for the `fault_with_*` tag. Therefore, when editing
      # the following hash, you should always check whether there is
      # a corresponding trigger to add/remove/edit. Search all triggers:
      # https://govuk.zendesk.com/admin/objects-rules/rules/triggers/
      # ("Conditions" -> "Tags" -> "Contains at least one of the following")
      OPTIONS = {
        "collections_publisher" => "Collections Publisher",
        "content_data" => "Content Data",
        "content_tagger" => "Content Tagger",
        "email_alerts" => "Email alerts",
        "feedback_explorer" => "Feedback explorer",
        "gov_uk_content" => "GOV.UK: content",
        "local_links_manager" => "Local Links Manager",
        "mainstream_publisher" => "Mainstream Publisher",
        "manuals_publisher" => "Manuals Publisher",
        "maslow" => "Maslow",
        "places_manager" => "Places Manager (formerly Imminence)",
        "search" => "Search",
        "service_manual_publisher" => "Service Manual Publisher",
        "short_url_manager" => "Short URL Manager",
        "signon" => "Signon",
        "smart_answers" => "Smart Answers",
        "specialist_publisher" => "Specialist Publisher",
        "support" => "Support app",
        "transition" => "Transition",
        "travel_advice_publisher" => "Travel Advice Publisher",
        "whitehall" => "Whitehall",
        "do_not_know" => "Other / do not know",
      }.freeze

      validates :fault_context, :fault_specifics, :actions_leading_to_problem, :what_happened, :what_should_have_happened, presence: true
      validates :fault_context, inclusion: { in: OPTIONS.keys }

      def fault_context_options
        OPTIONS.map { |key, value| [value, key] }
      end

      def formatted_fault_context
        OPTIONS[fault_context]
      end

      def fault_subject
        return "Technical fault report" if fault_context == "do_not_know"

        "Technical fault with #{formatted_fault_context}"
      end

      def self.label
        "Report a technical fault to GDS"
      end

      def self.description
        "Report something that is not working with any publishing application, e.g. Whitehall, finders or specialist publisher. Also use for any urgent technical changes."
      end
    end
  end
end
