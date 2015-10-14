require 'active_model/model'

module Support
  module GDS
    class RequestedUser
      include ActiveModel::Model
      attr_accessor :name, :email, :job, :phone, :training

      validates_presence_of :name, :email, :training
      validates :email, :format => {:with => /@/}
    end
  end
end
