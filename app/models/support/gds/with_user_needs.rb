module Support
  module GDS
    module WithUserNeeds
      attr_accessor :user_needs, :mainstream_changes, :maslow, :other_details, :become_organisation_admin, :become_super_organisation_admin

      def self.included(base)
        base.validates :formatted_user_needs, presence: { message: "must select at least one option" }
      end

      def formatted_user_needs
        needs_list = []
        needs_list << Hash[whitehall_account_options].key(user_needs)
        needs_list << Hash[other_permissions_options].key("mainstream_changes") if self.mainstream_changes == "1"
        needs_list << Hash[other_permissions_options].key("maslow") if self.maslow == "1"
        needs_list << Hash[other_permissions_options].key("become_organisation_admin") if self.become_organisation_admin == "1"
        needs_list << Hash[other_permissions_options].key("become_super_organisation_admin") if self.become_super_organisation_admin == "1"
        needs_list << "Other: #{self.other_details}" if self.other_details.present?
        needs_list.reject(&:blank?).compact.join("\n")
      end

      def inside_government_related?
        %w{editor writer managing_editor}.include?(user_needs)
      end

      def whitehall_account_options
        [
          ["Writer - can create content", "writer"],
          ["Editor - can create, review and publish content", "editor"],
          ["Managing editor - can create, review and publish content, and has admin rights", "managing_editor"],
        ]
      end

      def other_permissions_options
        [
          ["Request changes to your organisation’s mainstream content", "mainstream_changes"],
          ["Access to Maslow database of user needs", "maslow"],
          ["Request permission to be your organisation admin", "become_organisation_admin"],
          ["Request permission to be a super organisation admin", "become_super_organisation_admin"],
        ]
      end
    end
  end
end
