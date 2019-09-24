require "active_model/model"

module Support
  module Requests
    class Requester
      include ActiveModel::Model
      attr_accessor :name
      attr_reader :email

      validates_presence_of :email

      validates :email, format: { with: /@/ }

      validates_presence_of :name

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
        unless collaborator_emails.blank?
          collaborator_emails.each do |collaborator_email|
            unless collaborator_email =~ /@/
              errors.add(:collaborator_emails, "#{collaborator_email} is not a valid email")
            end
          end
        end
      end
    end
  end
end
