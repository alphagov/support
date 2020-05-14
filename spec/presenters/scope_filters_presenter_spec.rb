require "rails_helper"

describe ScopeFiltersPresenter, type: :presenter do
  describe "#paths" do
    it "extracts the path from an https URL" do
      presenter = described_class.new(paths: ["https://www.gov.uk/some-path", "https://www.gov.uk/other-path"])
      expect(presenter.paths).to eq("/some-path, /other-path")
    end

    it "extracts the path from an http URL" do
      presenter = described_class.new(paths: ["http://www.gov.uk/some-path", "http://www.gov.uk/other-path"])
      expect(presenter.paths).to eq("/some-path, /other-path")
    end

    it "can extract the path from a URL with a malformed protocol" do
      [
        "http:///www.gov.uk/abc",
        "http//:www.gov.uk/abc",
        "http/:www.gov.uk/abc",
        "http:/www.gov.uk/abc",
      ].each do |malformed_protocol_url|
        presenter = described_class.new(paths: [malformed_protocol_url])
        expect(presenter.paths).to eq("/abc")
      end
    end

    it "can extract the path from short-hand URLs" do
      [
        "www.gov.uk/abc",
        "gov.uk/abc",
        "/abc",
        "abc",
      ].each do |shorthand_url|
        presenter = described_class.new(paths: [shorthand_url])
        expect(presenter.paths).to eq("/abc")
      end
    end

    it "falls back to the supplied path if it's exceptionally badly formed" do
      [
        "123://1345",
      ].each do |badly_formed_url|
        presenter = described_class.new(paths: [badly_formed_url])
        expect(presenter.paths).to eq(badly_formed_url)
      end
    end

    it "extracts '/' as the path from a root style URL" do
      [
        "/",
        "http://gov.uk",
      ].each do |root_style_path|
        presenter = described_class.new(paths: [root_style_path])
        expect(presenter.paths).to eq("/")
      end
    end

    it "is root path for blank URLs" do
      [
        nil,
        "",
      ].each do |blank_url|
        presenter = described_class.new(paths: [blank_url])
        expect(presenter.paths).to eq "/"
      end
    end

    it "is root path for multiple blank URLs" do
      presenter = described_class.new(paths: [nil, ""])
      expect(presenter.paths).to eq "/"
    end

    it "is root path for missing URLs in a list" do
      missing_urls = [" ", " ", "http://www.gov.uk/some-path"]

      presenter = described_class.new(paths: missing_urls)
      expect(presenter.paths).to eq "/, /some-path"
    end
  end

  describe "#filtered?" do
    it "is false when `paths` and `organisation_slug` are blank" do
      presenter = described_class.new(paths: nil, organisation_slug: nil)
      expect(presenter).not_to be_filtered
    end

    it "is true when `paths` is provided and `organisation_slug` is blank" do
      presenter = described_class.new(paths: ["/done/buying-a-new-hat"], organisation_slug: nil)
      expect(presenter).to be_filtered
    end

    it "is true when `organisation_slug` is provided and `paths` is blank" do
      presenter = described_class.new(paths: nil, organisation_slug: "department-of-hats")
      expect(presenter).to be_filtered
    end

    it "is true when both `organisation_slug` and `path` are provided" do
      presenter = described_class.new(paths: ["/done/buying-a-new-hat"], organisation_slug: "department-of-hats")
      expect(presenter).to be_filtered
    end
  end

  describe "#invalid_filter?" do
    it "is true when `path` and `organisation_slug` are blank" do
      presenter = described_class.new(paths: nil, organisation_slug: nil)
      expect(presenter).to be_invalid_filter
    end

    it "is false when `paths` is provided and `organisation_slug` is blank" do
      presenter = described_class.new(paths: ["/done/buying-a-new-hat"], organisation_slug: nil)
      expect(presenter).not_to be_invalid_filter
    end

    it "is false when `organisation_slug` is provided and `paths` is blank" do
      presenter = described_class.new(paths: nil, organisation_slug: "department-of-hats")
      expect(presenter).not_to be_invalid_filter
    end

    it "is false when both `organisation_slug` and `paths` are provided" do
      presenter = described_class.new(paths: ["/done/buying-a-new-hat"], organisation_slug: "department-of-hats")
      expect(presenter).not_to be_invalid_filter
    end
  end

  describe "#done_page?" do
    it "is false when no path was provided" do
      presenter = described_class.new(paths: nil)
      expect(presenter).not_to be_done_page
    end

    context "with one single path" do
      it 'is true when the provided paths starts with "/done"' do
        presenter = described_class.new(paths: ["/done/buying-a-new-hat"])
        expect(presenter).to be_done_page
      end

      it 'is true when the provided paths starts with "done"' do
        presenter = described_class.new(paths: ["done/buying-a-new-hat"])
        expect(presenter).to be_done_page
      end

      it "is false when the provided paths starts with anything else" do
        presenter = described_class.new(paths: ["/start/buying-a-new-hat"])
        expect(presenter).not_to be_done_page
      end

      it "is false when the provided paths has done somewhere other than the start" do
        presenter = described_class.new(paths: ["/start/getting-things-done"])
        expect(presenter).not_to be_done_page
      end
    end

    context "with multiple paths" do
      it 'is true when one of the provided paths starts with "/done"' do
        presenter = described_class.new(paths: ["vat-rates", "/guidance/", "/done/buying-a-new-hat"])
        expect(presenter).to be_done_page
      end

      it 'is true when one of the provided paths starts with "done"' do
        presenter = described_class.new(paths: ["vat-rates", "/guidance/", "/done/buying-a-new-hat"])
        expect(presenter).to be_done_page
      end

      it "is false when all of the provided paths start with anything else" do
        presenter = described_class.new(paths: ["vat-rates", "/guidance/", "/start/buying-a-new-hat"])
        expect(presenter).not_to be_done_page
      end

      it "is false when one of the provided paths has done somewhere other than the start" do
        presenter = described_class.new(paths: ["vat-rates", "/guidance/", "/start/getting-things-done"])
        expect(presenter).not_to be_done_page
      end
    end
  end

  describe "#path_set_id" do
    include GdsApi::TestHelpers::SupportApi

    it "path_set_id is present" do
      presenter = described_class.new(path_set_id: "123")
      expect(presenter.path_set_id).to eq "123"
    end

    it "is nil when path_set_id is not present" do
      presenter = described_class.new
      expect(presenter.path_set_id).to eq nil
    end
  end

  describe "#organisation" do
    include GdsApi::TestHelpers::SupportApi

    it "fetches the org from the support api using the supplied slug" do
      org_request = stub_support_api_organisation(
        "department-of-hats",
        slug: "department-of-hats",
        web_url: "https://www.gov.uk/government/organisations/department-of-hats",
        title: "Department of Hats",
        acronym: "DoH",
        govuk_status: "live",
      )
      presenter = described_class.new(organisation_slug: "department-of-hats")
      presenter.organisation
      expect(org_request).to have_been_requested
    end

    it "does not talk to the support api if the organisation slug is not present" do
      org_request = stub_support_api_organisation(
        "department-of-hats",
        slug: "department-of-hats",
        web_url: "https://www.gov.uk/government/organisations/department-of-hats",
        title: "Department of Hats",
        acronym: "DoH",
        govuk_status: "live",
      )
      presenter = described_class.new(organisation_slug: nil)
      presenter.organisation
      expect(org_request).not_to have_been_requested
    end

    it "raises any error from the support API" do
      stub_any_support_api_call.to_return(status: 500)
      presenter = described_class.new(organisation_slug: "department-of-hats")
      expect {
        presenter.organisation
      }.to raise_error GdsApi::HTTPErrorResponse
    end
  end

  describe "#organisation_title" do
    include GdsApi::TestHelpers::SupportApi

    it "delegates to the org from the support api using the supplied slug" do
      stub_support_api_organisation(
        "department-of-hats",
        slug: "department-of-hats",
        web_url: "https://www.gov.uk/government/organisations/department-of-hats",
        title: "Department of Hats",
        acronym: "DoH",
        govuk_status: "live",
      )
      presenter = described_class.new(organisation_slug: "department-of-hats")
      expect(presenter.organisation_title).to eq "Department of Hats"
    end

    it "is nil if no organisation_slug was provided" do
      presenter = described_class.new(organisation_slug: nil)
      expect(presenter.organisation_title).to eq nil
    end
  end

  describe "#paths_title" do
    it "is nil if no paths were provided" do
      presenter = described_class.new(paths: nil)
      expect(presenter.paths_title).to eq nil
    end

    it "it is the single path of only one is provided" do
      presenter = described_class.new(paths: ["/done/buying-a-new-hat"])
      expect(presenter.paths_title).to eq "/done/buying-a-new-hat"
    end

    it "it shortens the title if an extra path is provided" do
      presenter = described_class.new(paths: ["/done/buying-a-new-hat", "/done/selling-an-old-hat"])
      expect(presenter.paths_title).to eq "/done/buying-a-new-hat and 1 other path"
    end

    it "it shortens the title if more than one extra path is provided" do
      presenter = described_class.new(paths: ["/done/buying-a-new-hat", "/done/selling-an-old-hat", "/done/selling-a-newish-hat"])
      expect(presenter.paths_title).to eq "/done/buying-a-new-hat and 2 other paths"
    end
  end

  describe "#document_type_title" do
    include GdsApi::TestHelpers::SupportApi

    it "delegates to the org from the support api using the supplied slug" do
      stub_support_api_anonymous_feedback_doc_type_summary(document_type: "smart_answer")
      presenter = described_class.new(document_type: "smart_answer")
      expect(presenter.document_type_title).to eq "Document type: smart answer"
    end

    it "is nil if no document_type was provided" do
      presenter = described_class.new(document_type: nil)
      expect(presenter.document_type_title).to eq nil
    end
  end

  describe "#to_s" do
    before do
      stub_support_api_organisation(
        "department-of-hats",
        slug: "department-of-hats",
        web_url: "https://www.gov.uk/government/organisations/department-of-hats",
        title: "Department of Hats",
        acronym: "DoH",
        govuk_status: "live",
      )

      stub_support_api_anonymous_feedback_doc_type_summary(document_type: "smart_answer")
    end
    it 'is "Everything" when paths, organisation and document_type are omitted' do
      presenter = described_class.new(paths: nil, organisation_slug: nil, document_type: nil)
      expect(presenter.to_s).to eq "Everything"
    end

    it "is the paths when paths is provided and organisation and document type are blank" do
      presenter = described_class.new(paths: ["/done/buying-a-new-hat"], organisation_slug: nil, document_type: nil)
      expect(presenter.to_s).to eq "/done/buying-a-new-hat"
    end

    it "is the organisation title when organisation is provided and paths and document_type are blank" do
      presenter = described_class.new(paths: nil, organisation_slug: "department-of-hats", document_type: nil)
      expect(presenter.to_s).to eq "Department of Hats"
    end

    it "is the document type title when document_type is provided and path and organisation are blank" do
      presenter = described_class.new(paths: nil, organisation_slug: nil, document_type: "smart_answer")
      expect(presenter.to_s).to eq "Document type: smart answer"
    end

    it "is the organisation title and path and document type when all three are provided" do
      presenter = described_class.new(
        paths: ["/done/buying-a-new-hat"],
        organisation_slug: "department-of-hats",
        document_type: "smart_answer",
      )
      expect(presenter.to_s).to eq "Department of Hats on /done/buying-a-new-hat - Document type: smart answer"
    end

    it "is the organisation title and paths when 1 path is provided" do
      presenter = described_class.new(paths: ["/done/buying-a-new-hat"], organisation_slug: "department-of-hats")
      expect(presenter.to_s).to eq "Department of Hats on /done/buying-a-new-hat"
    end

    it "is the organisation title and paths when 2 paths are provided" do
      presenter = described_class.new(paths: ["/done/buying-a-new-hat", "/done/selling-an-old-hat"], organisation_slug: "department-of-hats")
      expect(presenter.to_s).to eq "Department of Hats on /done/buying-a-new-hat and 1 other path"
    end

    it "is the organisation title, document type and paths when more than 2 paths are provided" do
      presenter = described_class.new(
        paths: ["/done/buying-a-new-hat", "/done/selling-an-old-hat", "/done/selling-a-newish-hat"],
        organisation_slug: "department-of-hats",
        document_type: "smart_answer",
      )
      expect(presenter.to_s).to eq "Department of Hats on /done/buying-a-new-hat and 2 other paths - Document type: smart answer"
    end
  end
end
