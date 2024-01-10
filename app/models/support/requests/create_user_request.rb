module Support
  module Requests
    class CreateUserRequest < Request
      attr_accessor :user_name, :user_email, :other_apps

      def self.label
        "Request a new user account"
      end

      def self.description
        "Request to create a user"
      end
    end
  end
end
