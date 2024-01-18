module Support
  module Requests
    class CreateNewUserRequest < Request
      attr_accessor(
        :name,
        :email,
        :organisation,
        :requires_additional_access,
      )

      attr_writer(
        :additional_comments,
      )

      validates :name, presence: true
      validates :email, presence: true, format: { with: /@/, allow_blank: true }
      validates :requires_additional_access, inclusion: { in: %w[yes no] }
      validates :additional_comments, presence: true, if: :requires_additional_access?

      def requires_additional_access?
        requires_additional_access == "yes"
      end

      def additional_comments
        requires_additional_access? ? @additional_comments : ""
      end

      def action
        "create_new_user"
      end

      def formatted_action
        "Create a new user account"
      end

      def inside_government_related?
        false
      end

      def self.label
        "Create a new user"
      end

      def self.description
        "Request a new user account."
      end
    end
  end
end
