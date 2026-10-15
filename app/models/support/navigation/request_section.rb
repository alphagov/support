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
        namespaced_route_key = @request_class.model_name.singular_route_key
        route_key = namespaced_route_key.sub("support_requests_", "").to_sym
        path_name = "new_#{route_key}_path"
        Rails.application.routes.url_helpers.send(path_name)
      end

      def accessible?
        @current_user.can?(:create, @request_class)
      end
    end
  end
end
