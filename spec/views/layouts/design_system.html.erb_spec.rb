require "rails_helper"

RSpec.describe "layouts/design_system" do
  before do
    allow(view).to receive_messages(navigation_items: [], user_signed_in?: false)
  end

  describe "flash alerts" do
    it "renders an error alert when flash[:alert] is present" do
      flash[:alert] = "Something went wrong"

      render

      expect(rendered).to include("Something went wrong")
    end

    it "renders a success alert when flash[:success_alert] is present" do
      flash[:success_alert] = { message: "Request sent" }

      render

      expect(rendered).to include("Request sent")
    end
  end
end
