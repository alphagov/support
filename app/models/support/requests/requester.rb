require "active_model/model"

module Support
  module Requests
    class Requester
      include ActiveModel::Model
      attr_accessor :name
      attr_reader :email

      VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

      validates :email, presence: true

      validates :email, format: { with: VALID_EMAIL_REGEX }

      validates :name, presence: true

      validate :collaborator_emails_are_all_valid

      def email=(new_email)
        @email = new_email.nil? ? nil : new_email.delete("\s")
      end

      def collaborator_emails
        (@collaborator_emails || []).reject { |collab| collab == email }
      end

      def collaborator_emails=(emails_as_string)
        @collaborator_emails = emails_as_string.split(",").collect(&:strip)
      end

      class << self
        def anonymous
          Requester.new(email: ZENDESK_ANONYMOUS_TICKETS_REQUESTER_EMAIL, name: "Anonymous feedback")
        end
      end

    private

      def collaborator_emails_are_all_valid
        if collaborator_emails.present?
          collaborator_emails.each do |collaborator_email|
            unless VALID_EMAIL_REGEX.match?(collaborator_email)
              errors.add(:collaborator_emails, "#{collaborator_email} is not a valid email")
            end
          end
        end
      end
    end
  end
end
