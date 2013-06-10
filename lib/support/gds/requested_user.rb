require 'active_model/tableless_model'

module Support
  module GDS
    class RequestedUser < ActiveModel::TablelessModel
      attr_accessor :name, :email, :job, :phone

      validates_presence_of :name, :email, :job
      validates :email, :format => {:with => /@/}
    end
  end
end