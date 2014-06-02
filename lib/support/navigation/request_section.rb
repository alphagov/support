module Support
  module Navigation
    class RequestSection
      include ActionView::Helpers::UrlHelper

      attr_reader :request_class

      def initialize(request_class, current_user)
        @request_class = request_class
        @current_user = current_user
      end

      def label
        @request_class.label
      end

      def description
        @request_class.description
      end

      def link
        request_class_name = @request_class.name.split("::").last
        path_name = "new_#{request_class_name.underscore}_path"
        Rails.application.routes.url_helpers.send(path_name)
      end

      def accessible?
        @current_user.can?(:create, @request_class)
      end
    end
  end
end
