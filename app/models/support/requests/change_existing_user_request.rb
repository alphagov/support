module Support
  module Requests
    class ChangeExistingUserRequest < Request
      attr_accessor(
        :name,
        :email,
        :organisation,
        :additional_comments,
      )

      validates :name, presence: true
      validates :email, presence: true, format: { with: /@/ }
      validates :additional_comments, presence: true

      def action
        "change_user"
      end

      def formatted_action
        "Change an existing user's account"
      end

      def inside_government_related?
        false
      end

      def self.label
        "Change an existing user's account"
      end

      def self.description
        "Request changes to an existing user's account."
      end
    end
  end
end
