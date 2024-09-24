module Support
  module Requests
    class CreateNewUserRequest < Request
      attr_accessor(
        :name,
        :email,
        :organisation,
        :access_to_whitehall_publisher,
        :access_to_other_publishing_apps,
        :additional_comments,
      )

      validates :name, :email, presence: true
      validates :email, format: { with: /@/ }
      validates :access_to_whitehall_publisher,
                inclusion: { in: :access_to_whitehall_publisher_option_keys, allow_blank: false }
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

      def access_to_whitehall_publisher_options
        {
          "not_required" => "No, the user does not need to draft or publish content on Whitehall Publisher",
          "publishing_training_required_press_officer" => "Yes, they need Writing and Publishing on GOV.UK for press officers training",
          "publishing_training_required_standard" => "Yes, they need Writing and Publishing on GOV.UK training",
          "publishing_training_completed" => "They’ve completed training and need a Production account to access Whitehall Publisher",
        }
      end

      def access_to_whitehall_publisher_option_keys
        access_to_whitehall_publisher_options.keys
      end

      def formatted_access_to_whitehall_publisher_option
        access_to_whitehall_publisher_options[access_to_whitehall_publisher]
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
