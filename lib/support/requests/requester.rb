require 'active_model/tableless_model'

module Support
  module Requests
    class Requester < ActiveModel::TablelessModel
      attr_accessor :email, :name

      validates_presence_of :email

      validates :email, format: { with: /@/ }

      validates_presence_of :name

      validate :collaborator_emails_are_all_valid

      def email=(new_email)
        @email = new_email.nil? ? nil : new_email.gsub("\s", "")
      end

      def collaborator_emails
        (@collaborator_emails || []).reject { |collab| collab == email }
      end

      def collaborator_emails=(emails_as_string)
        @collaborator_emails = emails_as_string.split(",").collect(&:strip)
      end

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