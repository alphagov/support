module Support
  module Navigation
    class SectionGroup
      attr_reader :label, :sections

      def initialize(label, sections)
        @label = label
        @sections = sections
      end
    end
  end
end
