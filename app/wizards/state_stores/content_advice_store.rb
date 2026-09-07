module StateStores
  class ContentAdviceStore
    include DfE::Wizard::StateStore

    def short_url_request?
      type == "short_url_request"
    end

    def org_page_request?
      type == "organisation_page"
    end
  end
end
