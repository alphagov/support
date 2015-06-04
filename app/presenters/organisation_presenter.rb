class OrganisationPresenter
  attr_reader :slug, :title

  def initialize(api_response)
    @slug = api_response["slug"]
    @title = api_response["title"]
  end
end
