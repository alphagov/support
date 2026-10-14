module Support
  module Navigation
    class ContentAdviceSections < Sections
      include Enumerable

      ORDERED_INDEX_ITEMS = [
        Support::Requests::ContentAdvice::ContentDesignHelpRequest,
        Support::Requests::ContentAdvice::OrganisationPageRequest,
        Support::Requests::ContentAdvice::GroupPageRequest,
        Support::Requests::ContentAdvice::ShortUrlRequest,
      ].freeze

      def initialize(current_user)
        super
        @sections = build_sections(current_user)
      end
    end
  end
end
