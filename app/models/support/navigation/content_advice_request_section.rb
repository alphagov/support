module Support
  module Navigation
    class ContentAdviceRequestSection
      include ActionView::Helpers::UrlHelper

      def initialize(current_user)
        @current_user = current_user
      end

      def label
        "Content advice and help sub-index"
      end

      def description
        "Find forms to request help with content design and publishing, including requests for new organisation pages, group pages and short URLs."
      end

      def link
        Rails.application.routes.url_helpers.content_advice_root_path
      end

      def accessible?
        @current_user.can? :read, self.class
      end
    end
  end
end
