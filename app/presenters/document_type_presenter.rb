class DocumentTypePresenter
  attr_reader :document_type

  def initialize(api_response)
    @document_type = api_response["document_type"]
  end
end
