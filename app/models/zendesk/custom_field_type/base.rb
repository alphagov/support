module Zendesk
  module CustomFieldType
    class Base
      attr_reader :id, :name

      def initialize(args)
        @id = args[:id]
        @name = args[:name]
      end
    end
  end
end
