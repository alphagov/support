require "rails_helper"

RSpec.describe "Starting sign-in via /auth/gds", type: :request do
  it "starts sign-in normally for an ordinary query string" do
    get "/auth/gds?this=is-fine"

    expect(response).to have_http_status(:redirect)
    expect(response.location).to include("/oauth/authorize")
    expect(request.session["omniauth.params"]).to eq({ "this" => "is-fine" })
  end

  it "still redirects to signon with an oversized query string but removes the latter" do
    get "/auth/gds?junk=also-#{'very-' * 2000}long"

    expect(response).to have_http_status(:redirect)
    expect(response.location).to include("/oauth/authorize")
    expect(request.session["omniauth.params"]).to eq({})
  end

  it "starts sign-in normally for an ordinary referer" do
    referer = "https://support.publishing.service.gov.uk/anonymous_feedback"
    get "/auth/gds", headers: { "Referer" => referer }

    expect(response).to have_http_status(:redirect)
    expect(response.location).to include("/oauth/authorize")
    expect(request.session["omniauth.origin"]).to eq(referer)
  end

  it "still redirects to signon with an oversized Referer header but removes the latter" do
    get "/auth/gds", headers: { "Referer" => "https://example.com/this-is-#{'very-' * 2000}long" }

    expect(response).to have_http_status(:redirect)
    expect(response.location).to include("/oauth/authorize")
    expect(request.session["omniauth.origin"]).to be_nil
  end
end
