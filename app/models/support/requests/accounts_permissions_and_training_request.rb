module Support
  module Requests
    class AccountsPermissionsAndTrainingRequest < Request
      attr_accessor :action,
                    :requested_user,
                    :additional_comments,
                    :user_needs,
                    :mainstream_changes,
                    :maslow,
                    :other_details,
                    :become_organisation_admin,
                    :become_super_organisation_admin

      validate do |request|
        if request.requested_user && !request.requested_user.valid?
          errors[:base] << "The details of the user in question are either incomplete or invalid."
        end
      end
      validates :action, :requested_user, presence: true
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
          "Change an existing user's account" => "change_user",
          "Create a new user account (non-Whitehall only)" => "create_new_user",
        }
      end

      def action_options
        self.class.action_options
      end

      def formatted_user_needs
        needs_list = []
        needs_list << whitehall_account_options.key(user_needs)
        needs_list << other_permissions_options.key("mainstream_changes") if mainstream_changes == "1"
        needs_list << other_permissions_options.key("maslow") if maslow == "1"
        needs_list << other_permissions_options.key("become_organisation_admin") if become_organisation_admin == "1"
        needs_list << other_permissions_options.key("become_super_organisation_admin") if become_super_organisation_admin == "1"
        needs_list << "Other: #{other_details}" if other_details.present?
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
        "New accounts (non-Whitehall) and changing permissions"
      end

      def self.description
        "Request a change to existing accounts and new accounts (non-Whitehall)."
      end

      def self.detailed_description
        <<~TEXT
          Request a change of permissions for an existing account, or a new account for a non-Whitehall user.
          New Whitehall users must first complete training.
          If this is what you need, please go back a step and select the ‘New accounts (Whitehall) and training’ option.
        TEXT
      end

      def self.suspension
        "If your account is suspended, speak to your organisation’s content lead or managing editor to unsuspend your account."
      end
    end
  end
end
