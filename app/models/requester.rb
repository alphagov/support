require 'tableless_model'

class Requester < TablelessModel
  attr_accessor :name, :email, :job, :phone, :organisation, :other_organisation

  validates_presence_of :name, :email, :job
  validates :email, :format => {:with => /^[\w\d]+[^@]*@[\w\d]+[^@]*\.[\w\d]+[^@]*$/}
end