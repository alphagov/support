module Support
  module Requests
    class CreateNewUserRequest < Request
      attr_accessor(
        :name,
        :email,
        :organisation,
        :additional_comments,
      )

      validates :name, :email, presence: true
      validates :email, format: { with: /@/ }
      validates :additional_comments, presence: true

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
    end
  end
end
