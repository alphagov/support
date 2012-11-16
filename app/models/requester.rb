require 'tableless_model'

class Requester < TablelessModel
  attr_accessor :name, :email, :job, :phone, :organisation, :other_organisation

  validates_presence_of :name, :email, :job
  validates_presence_of :organisation, :message => "information is required for a valid request."
  validates :email, :format => {:with => /^[\w\d]+[^@]*@[\w\d]+[^@]*\.[\w\d]+[^@]*$/}
  validates_presence_of :other_organisation, :if => Proc.new {|request| request.organisation == "other_organisation"}
end