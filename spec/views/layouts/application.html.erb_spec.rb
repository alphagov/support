require 'rails_helper'

describe 'layouts/application' do
  before do
    allow(view).to receive(:current_user) { build(:user, name: "John") }
    render
  end

  it "shows the name of the user who is logged in" do
    expect(rendered).to have_selector('nav a', text: "John")
  end

  it "shows have a link to log out" do
    expect(rendered).to have_selector('a[href="/auth/gds/sign_out"]', text: "Sign out")
  end
end
