module Support
  module Requests
    class AccountsPermissionsAndTrainingRequest < Request
      attr_accessor :action, :requested_user, :additional_comments,
                    :user_needs, :mainstream_changes, :maslow,
                    :other_details, :become_organisation_admin,
                    :become_super_organisation_admin

      validate do |request|
        if request.requested_user && !request.requested_user.valid?
          errors[:base] << "The details of the user in question are either incomplete or invalid."
        end
      end
      validates_presence_of :action, :requested_user
      validates :action, inclusion: { in: ->(request) { request.action_options.values } }
      validates :formatted_user_needs, presence: { message: "must select at least one option" }

      def requested_user_attributes=(attr)
        self.requested_user = Support::GDS::RequestedUser.new(attr)
      end

      def initialize(attrs = {})
        self.requested_user = Support::GDS::RequestedUser.new

        super
      end

      def for_new_user?
        action == "create_new_user"
      end

      def formatted_action
        action_options.key(action)
      end

      def self.action_options
        @action_options ||= {
          "Create a new user account" => "create_new_user",
          "Change an existing user's account" => "change_user",
        }
      end

      def action_options
        self.class.action_options
      end

      def formatted_user_needs
        needs_list = []
        needs_list << whitehall_account_options.key(user_needs)
        needs_list << other_permissions_options.key("mainstream_changes") if self.mainstream_changes == "1"
        needs_list << other_permissions_options.key("maslow") if self.maslow == "1"
        needs_list << other_permissions_options.key("become_organisation_admin") if self.become_organisation_admin == "1"
        needs_list << other_permissions_options.key("become_super_organisation_admin") if self.become_super_organisation_admin == "1"
        needs_list << "Other: #{self.other_details}" if self.other_details.present?
        needs_list.reject(&:blank?).compact.join("\n")
      end

      def inside_government_related?
        whitehall_account_options.value?(user_needs)
      end

      def self.whitehall_account_options
        @whitehall_account_options ||= {
          "Writer - can create content" => "writer",
          "Editor - can create, review and publish content" => "editor",
          "Managing editor - can create, review and publish content, and has admin rights" => "managing_editor",
        }
      end

      def whitehall_account_options
        self.class.whitehall_account_options
      end

      def self.other_permissions_options
        @other_permissions_options ||= {
          "Request changes to your organisation’s mainstream content" => "mainstream_changes",
          "Access to Maslow database of user needs" => "maslow",
          "Request permission to be your organisation admin" => "become_organisation_admin",
          "Request permission to be a super organisation admin" => "become_super_organisation_admin",
        }
      end

      def other_permissions_options
        self.class.other_permissions_options
      end

      def self.label
        "Accounts, permissions and training"
      end

      def self.description
        "Request a new Whitehall account or change permissions."
      end

      def self.suspension
        "If your account is suspended, speak to your organisation’s content lead or managing editor to unsuspend your account."
      end
    end
  end
end
