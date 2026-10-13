require "rails_helper"

describe "support/_new_request_links" do
  let(:user) { build(:user) }

  before do
    allow(view).to receive(:current_user) { user }
  end

  it "renders a link for making a new request" do
    render("support/new_request_links")
    expect(rendered).to have_link("Make new request", href: root_path)
  end

  it "renders a feedex link" do
    render("support/new_request_links")
    expect(rendered).to have_selector("#feedex a", text: "Feedback explorer")
  end
end
