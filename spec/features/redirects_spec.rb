require 'rails_helper'
require 'uri'

describe "legacy feedex URL redirect" do
  before do
    login_as create(:feedex_user)
  end

  it "redirects the legacy feedex landing page to the current feedex landing page" do
    visit '/anonymous_feedback/problem_reports/explore'
    expect(page.current_path).to eq('/anonymous_feedback/explore')
  end

  it "redirects the old problem report deep-links to the current anon feedback links" do
    visit '/anonymous_feedback/problem_reports?path=/vat-rates'
    expect(current_url).to eq(current_host + '/anonymous_feedback?path=%2Fvat-rates')
  end
end
