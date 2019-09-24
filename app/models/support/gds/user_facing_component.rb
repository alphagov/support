require "active_model/model"

module Support
  module GDS
    class UserFacingComponent
      include ActiveModel::Model
      attr_accessor :name, :id, :inside_government_related

      validates_presence_of :name, :id

      def inside_government_related?
        inside_government_related
      end
    end
  end
end
