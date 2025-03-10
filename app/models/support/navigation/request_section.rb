module Support
  module Navigation
    class RequestSection
      include ActionView::Helpers::UrlHelper

      attr_reader :request_class

      def initialize(request_class, current_user)
        @request_class = request_class
        @current_user = current_user
      end

      delegate :description, to: :@request_class
      delegate :label, to: :@request_class

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
