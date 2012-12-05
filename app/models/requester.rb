require 'tableless_model'

class Requester < TablelessModel
  attr_accessor :email

  validates_presence_of :email
  validates :email, :format => {:with => /@/}
end