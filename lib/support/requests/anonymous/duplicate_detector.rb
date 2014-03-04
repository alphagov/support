require 'support/requests/anonymous/anonymous_contact'

module Support
  module Requests
    module Anonymous
      # This class uses a sliding window to identify duplicates within a certain period of time
      # This assumes that data is being fed into the class in chronological order
      class DuplicateDetector
        def initialize
          @comparator = AnonymousFeedbackComparator.new
          @unique_records = []
        end

        def duplicate?(record)
          is_dupe = @unique_records.any? {|saved_record| @comparator.same?(saved_record, record)}
          unless is_dupe
            @unique_records.select! {|r| @comparator.created_within_a_short_interval?(r, record)}
            @unique_records << record
          end
          is_dupe
        end
      end

      class AnonymousFeedbackComparator
        DUPLICATION_INTERVAL_IN_SECONDS = 5

        def initialize
          @fields_to_compare = AnonymousContact.attribute_names - ["id", "created_at", "updated_at"]
        end

        def same?(r1, r2)
          fields_same?(r1, r2) && created_within_a_short_interval?(r1, r2)
        end

        def created_within_a_short_interval?(r1, r2)
          (r1["created_at"] - r2["created_at"]).abs < DUPLICATION_INTERVAL_IN_SECONDS
        end

        private
        def fields_same?(r1, r2)
          @fields_to_compare.all? {|field| r1[field] == r2[field] }
        end
      end
    end
  end
end
