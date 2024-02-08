module Support
  module Requests
    class TechnicalFaultReport < Request
      attr_accessor :fault_context, :fault_specifics, :actions_leading_to_problem, :what_happened, :what_should_have_happened

      OPTIONS = {
        "collections_publisher" => "Collections Publisher",
        "contacts_admin" => "Contacts Admin",
        "content_data" => "Content Data",
        "content_publisher" => "Content Publisher (beta)",
        "content_tagger" => "Content Tagger",
        "datagovuk" => "data.gov.uk",
        "gov_uk_content" => "GOV.UK: content",
        "imminence" => "Imminence",
        "local_links_manager" => "Local Links Manager",
        "mainstream_publisher" => "Mainstream Publisher",
        "manuals_publisher" => "Manuals Publisher",
        "maslow" => "Maslow",
        "service_manual_publisher" => "Service Manual Publisher",
        "short_url_manager" => "Short URL Manager",
        "signon" => "Signon",
        "specialist_publisher" => "Specialist Publisher",
        "travel_advice_publisher" => "Travel Advice Publisher",
        "whitehall" => "Whitehall",
      }.freeze

      validates :fault_context, :fault_specifics, :actions_leading_to_problem, :what_happened, :what_should_have_happened, presence: true
      validate do |report|
        if report.fault_context && !report.fault_context.valid?
          errors.add :base, message: "The source of the fault is not set."
        end
      end

      def initialize(opts = {})
        super
        self.fault_context ||= Support::GDS::UserFacingComponent.new
      end

      def fault_context_attributes=(attr)
        self.fault_context = if attr[:name] == "do_not_know"
                               do_not_know_component
                             else
                               Support::GDS::UserFacingComponents.find(attr)
                             end
      end

      def fault_context_options
        Support::GDS::UserFacingComponents.all + [do_not_know_component]
      end

      def do_not_know_component
        Support::GDS::UserFacingComponent.new(name: "Do not know", id: "do_not_know")
      end

      def self.label
        "Report a technical fault to GDS"
      end

      def self.description
        "Report something that is not working with any publishing application, eg Whitehall, finders or specialist publisher. Also use for any urgent technical changes"
      end
    end
  end
end
