module Support
  module Navigation
    class ContentAdviceSections < Sections
      include Enumerable

      ORDERED_REQUEST_FORMS = [
        Support::Requests::ContentAdvice::ContentDesignHelpRequest,
        Support::Requests::ContentAdvice::OrganisationPageRequest,
        Support::Requests::ContentAdvice::GroupPageRequest,
        Support::Requests::ContentAdvice::ShortUrlRequest,
      ].freeze

      def initialize(current_user)
        super
        @sections = request_sections(current_user)
      end
    end
  end
end
