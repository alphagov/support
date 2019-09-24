require "rails_helper"

describe "support/_new_request_links" do
  let(:user) { build(:user) }
  let(:section_groups) { Support::Navigation::SectionGroups.new(user) }

  before do
    allow(view).to receive(:current_user) { user }
  end

  it "marks the section as active if that's where the user is" do
    allow(view).to receive(:current_page?).and_return(true)
    render "support/new_request_links", section_groups: section_groups
    expect(rendered).to have_selector("ul.dropdown-menu li.active")
  end

  it "doesn't mark the section as active if the user is somewhere else" do
    allow(view).to receive(:current_page?).and_return(false)
    render "support/new_request_links", section_groups: section_groups
    expect(rendered).to_not have_selector("ul.dropdown-menu li.active")
  end

  it "renders a feedex link" do
    render "support/new_request_links", section_groups: section_groups
    expect(rendered).to have_selector("#feedex a", text: "Feedback explorer")
  end
end
