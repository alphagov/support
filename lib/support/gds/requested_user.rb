require 'active_model/model'

module Support
  module GDS
    class RequestedUser
      include ActiveModel::Model
      attr_accessor :name, :email, :job, :phone

      validates_presence_of :name, :email
      validates :email, :format => {:with => /@/}
    end
  end
end
