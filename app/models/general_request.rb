class GeneralRequest
  include ActiveAttr::Model

  attribute :name
  attribute :email
  attribute :job
  attribute :phone
  attribute :organisation
  attribute :other_organisation
  attribute :url
  attribute :additional
  attribute :user_agent

  validates_presence_of :name, :email, :job
  validates_presence_of :organisation, :message => "information is required for a valid request."
  validates :email, :format => {:with => /^[\w\d]+[^@]*@[\w\d]+[^@]*\.[\w\d]+[^@]*$/}
  validates_presence_of :other_organisation, :if => Proc.new {|request| request.organisation == "other_organisation"}
end