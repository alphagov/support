module Support
  module Navigation
    class EmergencyContactDetailsSection
      include ActionView::Helpers::UrlHelper

      def initialize(current_user)
        @current_user = current_user
      end

      def label
        "Emergency contact details"
      end

      def description
        "Contact GOV.UK in an emergency"
      end

      def link
        Rails.application.routes.url_helpers.emergency_contact_details_path
      end

      def accessible?
        @current_user.can? :read, self.class
      end
    end
  end
end
