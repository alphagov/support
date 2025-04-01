require "forwardable"

module Support
  module Requests
    class CreateNewUserRequest < Request
      extend Forwardable

      attr_accessor(
        :name,
        :email,
        :organisation,
        :new_or_existing_user,
        :whitehall_training,
        :access_to_other_publishing_apps,
        :writing_for_govuk_training,
        :additional_comments,
      )

      validates :name, :email, presence: true
      validates :email, format: { with: /@/ }
      validates :new_or_existing_user,
                inclusion: { in: :new_or_existing_user_option_keys, allow_blank: false }
      validates :whitehall_training,
                inclusion: { in: :whitehall_training_option_keys, allow_blank: false }
      validates :access_to_other_publishing_apps,
                inclusion: { in: :access_to_other_publishing_apps_option_keys, allow_blank: false }
      validates :writing_for_govuk_training,
                inclusion: { in: :writing_for_govuk_training_option_keys, allow_blank: true }
      validates :additional_comments,
                presence: true, if: -> { access_to_other_publishing_apps == "whitehall_training_additional_apps_access_yes" }

      def action
        "create_new_user"
      end

      def self.label
        "Create a new user or request training"
      end

      def_delegator self, :label, :formatted_action

      def self.description
        "Request a new user account."
      end

      def new_or_existing_user_options
        Zendesk::CustomField.options_hash("[Whitehall training] New or existing user?")
      end

      def new_or_existing_user_option_keys
        new_or_existing_user_options.keys
      end

      def formatted_new_or_existing_user_option
        new_or_existing_user_options[new_or_existing_user]
      end

      def whitehall_training_options
        Zendesk::CustomField.options_hash("[Whitehall training] Training required?")
      end

      def whitehall_training_option_keys
        whitehall_training_options.keys
      end

      def formatted_whitehall_training_option
        whitehall_training_options[whitehall_training]
      end

      def access_to_other_publishing_apps_options
        Zendesk::CustomField.options_hash("[Whitehall training] Access to other publishing Apps required?")
      end

      def access_to_other_publishing_apps_option_keys
        access_to_other_publishing_apps_options.keys
      end

      def formatted_access_to_other_publishing_apps_option
        access_to_other_publishing_apps_options[access_to_other_publishing_apps]
      end

      def writing_for_govuk_training_options
        Zendesk::CustomField.options_hash("[Whitehall training] Writing for GOV.UK training required?")
      end

      def writing_for_govuk_training_option_keys
        writing_for_govuk_training_options.keys
      end

      def formatted_writing_for_govuk_training_option
        writing_for_govuk_training_options[writing_for_govuk_training]
      end
    end
  end
end
