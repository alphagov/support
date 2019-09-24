require "rails_helper"

describe SupportController, type: :controller do
  it "renders the landing page" do
    login_as create(:user)
    get :landing
    expect(response).to have_http_status(:success)
  end

  context "the landing page" do
    it "lists all sections that the user can access as accessible" do
      login_as create(:user_who_can_access_everything)
      get :landing
      expect(assigns(:accessible_sections)).to_not be_empty
      expect(assigns(:inaccessible_sections)).to be_empty
    end

    it "lists all sections that the user cannot access as inaccessible" do
      login_as create(:user_who_cannot_access_anything)
      get :landing
      expect(assigns(:accessible_sections)).to be_empty
      expect(assigns(:inaccessible_sections)).to_not be_empty
    end
  end

  context "GET /_status" do
    it "is accessible without SSO" do
      @request.env["HTTP_ACCEPT"] = "application/json"

      get :queue_status

      expect(response).to have_http_status(:success)
    end

    it "return the status of the queues" do
      expect(Sidekiq::Stats).to receive(:new).and_return(
        double("stats", queues: [["queue_a", 3], ["queue_b", 5]]),
      )
      @request.env["HTTP_ACCEPT"] = "application/json"

      get :queue_status

      expect(json_response).to eq(
        "queues" => {
          "queue_a" => { "jobs" => 3 },
          "queue_b" => { "jobs" => 5 },
        },
      )
    end
  end
end
