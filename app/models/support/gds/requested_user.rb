require "active_model/model"

module Support
  module GDS
    class RequestedUser
      include ActiveModel::Model
      attr_accessor :name, :email, :job, :phone, :other_training

      validates :name, :email, presence: true
      validates :email, format: { with: /@/ }
    end
  end
end
