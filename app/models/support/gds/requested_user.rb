require "active_model/model"

module Support
  module GDS
    class RequestedUser
      include ActiveModel::Model
      attr_accessor :name, :email, :organisation

      validates :name, :email, presence: true
      validates :email, format: { with: /@/ }

      def job; end
      def phone; end
    end
  end
end
