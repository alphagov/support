module Support
  module Requests
    class CreateNewUserRequest < Request
      attr_accessor(
        :name,
        :email,
        :organisation,
        :additional_comments,
      )

      validates :name, presence: true
      validates :email, presence: true, format: { with: /@/, allow_blank: true }
      validates :additional_comments, presence: true

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
