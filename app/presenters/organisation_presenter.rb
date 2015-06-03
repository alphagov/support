class OrganisationPresenter
  attr_reader :title

  def initialize(api_response)
    @title = api_response["title"]
  end
end
