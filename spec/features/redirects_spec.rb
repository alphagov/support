require 'rails_helper'
require 'uri'
require 'gds_api/test_helpers/support_api'
require 'gds_api/test_helpers/organisations'

describe "legacy feedex URL redirect" do
  include GdsApi::TestHelpers::SupportApi
  include GdsApi::TestHelpers::Organisations

  def stub_organisations_api
    organisations_slugs = %w(department-of-fair-dos)
    organisations_api_has_organisations(organisations_slugs)
  end

  before do
    login_as create(:user)
  end

  it "redirects the legacy feedex landing page to the current feedex landing page" do
    stub_organisations_api

    visit '/anonymous_feedback/problem_reports/explore'
    expect(page.current_path).to eq('/anonymous_feedback/explore')
  end

  it "redirects the old problem report deep-links to the current anon feedback links" do
    stub_anonymous_feedback(
      { path_prefix: "/vat-etc" },
      {
        "current_page" => 1,
        "pages" => 1,
        "page_size" => 1,
        "results" => [],
      }
    )
    visit '/anonymous_feedback/problem_reports?path=/vat-etc'
    expect(current_url).to eq(current_host + '/anonymous_feedback?path=%2Fvat-etc')
  end
end
