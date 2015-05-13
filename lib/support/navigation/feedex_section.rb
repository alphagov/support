module Support
  module Navigation
    class FeedexSection
      include ActionView::Helpers::UrlHelper

      def initialize(current_user)
        @current_user = current_user
      end

      def label
        "Feedback explorer"
      end

      def description
        "GOV.UK Anonymous Feedback"
      end

      def link
        Rails.application.routes.url_helpers.anonymous_feedback_explore_path
      end

      def accessible?
        @current_user.can? :read, :anonymous_feedback
      end
    end
  end
end
