module Zendesk
  module CustomFieldType
    class Text < Base
      def prepare_value(input)
        input.to_s
      end
    end
  end
end
