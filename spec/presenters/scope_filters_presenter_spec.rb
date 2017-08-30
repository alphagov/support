require 'rails_helper'

describe ScopeFiltersPresenter, type: :presenter do
  describe '#path' do
    it "extracts the path from an https URL" do
      presenter = described_class.new(path: 'https://www.gov.uk/some-path')
      expect(presenter.path).to eq("/some-path")
    end

    it "extracts the path from an http URL" do
      presenter = described_class.new(path: 'http://www.gov.uk/some-path')
      expect(presenter.path).to eq("/some-path")
    end

    it "can extract the path from a URL with a malformed protocol" do
      [
        "http:///www.gov.uk/abc",
        "http//:www.gov.uk/abc",
        "http/:www.gov.uk/abc",
        "http:/www.gov.uk/abc",
      ].each do |malformed_protocol_url|
        presenter = described_class.new(path: malformed_protocol_url)
        expect(presenter.path).to eq("/abc")
      end
    end

    it "can extract the path from short-hand URLs" do
      [
        "www.gov.uk/abc",
        "gov.uk/abc",
        "/abc",
        "abc",
      ].each do |shorthand_url|
        presenter = described_class.new(path: shorthand_url)
        expect(presenter.path).to eq("/abc")
      end
    end

    it "falls back to the supplied path if it's exceptionally badly formed" do
      [
        "123://1345",
      ].each do |badly_formed_url|
        presenter = described_class.new(path: badly_formed_url)
        expect(presenter.path).to eq(badly_formed_url)
      end
    end

    it "extracts '/' as the path from a root style URL" do
      [
        "/",
        "http://gov.uk"
      ].each do |root_style_path|
        presenter = described_class.new(path: root_style_path)
        expect(presenter.path).to eq('/')
      end
    end

    it "is nil for blank URLs" do
      [
        nil,
        ""
      ].each do |blank_url|
        presenter = described_class.new(path: blank_url)
        expect(presenter.path).to be_nil
      end
    end
  end

  describe "#filtered?" do
    it 'is false when path and organisation are blank' do
      presenter = described_class.new(path: nil, organisation_slug: nil)
      expect(presenter).not_to be_filtered
    end

    it 'is true when path is provided and organisation is blank' do
      presenter = described_class.new(path: '/done/buying-a-new-hat', organisation_slug: nil)
      expect(presenter).to be_filtered
    end

    it 'is true when organisation is provided and path is blank' do
      presenter = described_class.new(path: nil, organisation_slug: 'department-of-hats')
      expect(presenter).to be_filtered
    end

    it 'is true when both organisation and path are provided' do
      presenter = described_class.new(path: '/done/buying-a-new-hat', organisation_slug: 'department-of-hats')
      expect(presenter).to be_filtered
    end
  end

  describe "#invalid_filter?" do
    it 'is true when path and organisation are blank' do
      presenter = described_class.new(path: nil, organisation_slug: nil)
      expect(presenter).to be_invalid_filter
    end

    it 'is false when path is provided and organisation is blank' do
      presenter = described_class.new(path: '/done/buying-a-new-hat', organisation_slug: nil)
      expect(presenter).not_to be_invalid_filter
    end

    it 'is false when organisation is provided and path is blank' do
      presenter = described_class.new(path: nil, organisation_slug: 'department-of-hats')
      expect(presenter).not_to be_invalid_filter
    end

    it 'is false when both organisation and path are provided' do
      presenter = described_class.new(path: '/done/buying-a-new-hat', organisation_slug: 'department-of-hats')
      expect(presenter).not_to be_invalid_filter
    end
  end

  describe "#done_page?" do
    it "is false when no path was provided" do
      presenter = described_class.new(path: nil)
      expect(presenter).not_to be_done_page
    end

    it 'is true when the provided path starts with "/done"' do
      presenter = described_class.new(path: "/done/buying-a-new-hat")
      expect(presenter).to be_done_page
    end

    it 'is true when the provided path starts with "done"' do
      presenter = described_class.new(path: "done/buying-a-new-hat")
      expect(presenter).to be_done_page
    end

    it 'is false when the provided path starts with anything else' do
      presenter = described_class.new(path: "/start/buying-a-new-hat")
      expect(presenter).not_to be_done_page
    end

    it 'is false when the provided path has done somewhere other than the start' do
      presenter = described_class.new(path: "/start/getting-things-done")
      expect(presenter).not_to be_done_page
    end
  end

  describe "#organisation" do
    include GdsApi::TestHelpers::SupportApi

    it "fetches the org from the support api using the supplied slug" do
      org_request = stub_support_api_organisation(
        "department-of-hats",
        slug: 'department-of-hats',
        web_url: "https://www.gov.uk/government/organisations/department-of-hats",
        title: "Department of Hats",
        acronym: "DoH",
        govuk_status: "live"
      )
      presenter = described_class.new(organisation_slug: 'department-of-hats')
      presenter.organisation
      expect(org_request).to have_been_requested
    end

    it "does not talk to the support api if the organisation slug is not present" do
      org_request = stub_support_api_organisation(
        "department-of-hats",
        slug: 'department-of-hats',
        web_url: "https://www.gov.uk/government/organisations/department-of-hats",
        title: "Department of Hats",
        acronym: "DoH",
        govuk_status: "live"
      )
      presenter = described_class.new(organisation_slug: nil)
      presenter.organisation
      expect(org_request).not_to have_been_requested
    end

    it "raises any error from the support API" do
      stub_any_support_api_call.to_return(status: 500)
      presenter = described_class.new(organisation_slug: 'department-of-hats')
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
        slug: 'department-of-hats',
        web_url: "https://www.gov.uk/government/organisations/department-of-hats",
        title: "Department of Hats",
        acronym: "DoH",
        govuk_status: "live"
      )
      presenter = described_class.new(organisation_slug: 'department-of-hats')
      expect(presenter.organisation_title).to eq 'Department of Hats'
    end

    it "is nil if no organisation_slug was provided" do
      presenter = described_class.new(organisation_slug: nil)
      expect(presenter.organisation_title).to eq nil
    end
  end

  describe '#to_s' do
    it 'is "Everything" when path and organisation are omitted' do
      presenter = described_class.new(path: nil, organisation_slug: nil)
      expect(presenter.to_s).to eq 'Everything'
    end

    it 'is the path when path is provided and organisation is blank' do
      presenter = described_class.new(path: '/done/buying-a-new-hat', organisation_slug: nil)
      expect(presenter.to_s).to eq '/done/buying-a-new-hat'
    end

    it 'is the organisation title when organisation is provided and path is blank' do
      stub_support_api_organisation(
        "department-of-hats",
        slug: 'department-of-hats',
        web_url: "https://www.gov.uk/government/organisations/department-of-hats",
        title: "Department of Hats",
        acronym: "DoH",
        govuk_status: "live"
      )

      presenter = described_class.new(path: nil, organisation_slug: 'department-of-hats')
      expect(presenter.to_s).to eq 'Department of Hats'
    end

    it 'is the organistion title and path when both organisation and path are provided' do
      stub_support_api_organisation(
        "department-of-hats",
        slug: 'department-of-hats',
        web_url: "https://www.gov.uk/government/organisations/department-of-hats",
        title: "Department of Hats",
        acronym: "DoH",
        govuk_status: "live"
      )

      presenter = described_class.new(path: '/done/buying-a-new-hat', organisation_slug: 'department-of-hats')
      expect(presenter.to_s).to eq 'Department of Hats on /done/buying-a-new-hat'
    end
  end
end
