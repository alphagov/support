module Support
  module Navigation
    class SectionGroup
      attr_reader :label, :sections

      def initialize(label, sections)
        @label = label
        @sections = sections
      end

      def accessible_sections
        @sections.select(&:accessible?)
      end

      def accessible?
        @sections.any?(&:accessible?)
      end
    end
  end
end
