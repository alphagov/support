require "active_model/model"

module Support
  module GDS
    class UserFacingComponent
      include ActiveModel::Model
      attr_accessor :name, :id

      validates :name, :id, presence: true
    end
  end
end
