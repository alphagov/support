require "active_model/model"

module Support
  module GDS
    class RequestedUser
      include ActiveModel::Model
      attr_accessor :name, :email, :organisation
    end
  end
end
