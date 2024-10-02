module Support
  module Requests
    class CreateNewUserRequest < Request
      attr_accessor(
        :name,
        :email,
        :organisation,
        :whitehall_training,
        :access_to_other_publishing_apps,
        :additional_comments,
      )

      validates :name, :email, presence: true
      validates :email, format: { with: /@/ }
      validates :whitehall_training,
                inclusion: { in: :whitehall_training_option_keys, allow_blank: false }
      validates :access_to_other_publishing_apps,
                inclusion: { in: :access_to_other_publishing_apps_option_keys, allow_blank: false }
      validates :additional_comments,
                presence: true, if: -> { access_to_other_publishing_apps == "required" }

      def action
        "create_new_user"
      end

      def formatted_action
        "Create a new user account"
      end

      def self.label
        "Create a new user"
      end

      def self.description
        "Request a new user account."
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
        {
          "not_required" => "No, the user does not need access to any other publishing application",
          "required" => "Yes, the user needs access to the applications and permissions listed below",
        }
      end

      def access_to_other_publishing_apps_option_keys
        access_to_other_publishing_apps_options.keys
      end

      def formatted_access_to_other_publishing_apps_option
        access_to_other_publishing_apps_options[access_to_other_publishing_apps]
      end
    end
  end
end
