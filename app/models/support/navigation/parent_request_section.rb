# frozen_string_literal: true

module Support
  module Navigation
    class ParentRequestSection < RequestSection
      def initialize(request_class, current_user, link)
        @link = link
        super(request_class, current_user)
      end

      attr_reader :link
    end
  end
end
