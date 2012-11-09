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

  validates_presence_of :name, :email, :job
  validates_presence_of :organisation, :message => "Organisation information is required for a valid request."
  validates :email, :format => {:with => /^[\w\d]+[^@]*@[\w\d]+[^@]*\.[\w\d]+[^@]*$/}
end