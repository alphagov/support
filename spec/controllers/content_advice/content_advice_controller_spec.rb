require "rails_helper"

describe ContentAdvice::ContentAdviceController, type: :controller do
  it "renders the content advice interstitial" do
    login_as create(:user)
    get :index
    expect(response).to have_http_status(:success)
  end

  context "the interstitial page" do
    it "lists all sections that the user can access as accessible" do
      login_as create(:user_who_can_access_everything)
      get :index
      expect(assigns(:accessible_sections)).to_not be_empty
      expect(assigns(:inaccessible_sections)).to be_empty
    end

    it "lists all sections that the user cannot access as inaccessible" do
      login_as create(:user_who_cannot_access_anything)
      get :index
      expect(assigns(:accessible_sections)).to be_empty
      expect(assigns(:inaccessible_sections)).to_not be_empty
    end
  end
end
