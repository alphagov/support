require 'shared/tableless_model'

module Support
  module Requests
    class RequestedUser < TablelessModel
      attr_accessor :name, :email, :job, :phone

      validates_presence_of :name, :email, :job
      validates :email, :format => {:with => /@/}
    end
  end
end