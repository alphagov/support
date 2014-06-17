module GovtRequestParams
  def valid_requester_params
    { "email"=>"testing@digital.cabinet-office.gov.uk" }
  end
end

RSpec.configure { |c| c.include GovtRequestParams }
