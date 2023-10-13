module Zendesk
  module CustomFieldType
    class DateField < Base
      def prepare_value(input)
        date = Date.parse(input)

        date.strftime("%F")
      end
    end
  end
end
