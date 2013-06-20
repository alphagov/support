require 'active_model/tableless_model'

module Support
  module GDS
    class UserFacingComponent < ActiveModel::TablelessModel
      attr_accessor :name, :id, :inside_government_related

      validates_presence_of :name, :id

      def inside_government_related?
        inside_government_related
      end
    end
  end
end
