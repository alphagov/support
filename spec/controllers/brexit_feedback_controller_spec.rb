describe BrexitFeedbackController, type: :controller do
  before do
    login_as create(:user)
    stub_support_api_organisations_list
    stub_support_api_document_type_list
  end
  context "when authorising" do
    it "redirects to google" do
      ENV["google_client_id"] = "fake_id"
      ENV["google_client_secret"] = "fake_secret"
      get :auth
      auth_uri = "https://accounts.google.com/o/oauth2/auth?access_type=offline&client_id=fake_id&include_granted_scopes=true&prompt=consent&redirect_uri=#{Plek.new.find('support')}/brexit/results&response_type=code&scope=https://www.googleapis.com/auth/spreadsheets.readonly"
      expect(response).to redirect_to(auth_uri)
      ENV.delete("google_client_id")
      ENV.delete("google_client_secret")
    end
  end

  context "when getting results" do
    before do
      session["auth_client"] = {
        "authorization_uri" => { "scheme" => "https", "host" => "accounts.google.com", "path" => "/o/oauth2/auth" },
        "token_credential_uri" => { "scheme" => "https", "host" => "oauth2.googleapis.com", "path" => "/token" },
        "redirect_uri" => { "scheme" => "http", "host" => "support.dev.gov.uk", "path" => "/brexit/results" },
        "client_id" => "fake_id",
        "client_secret" => "fake_secret",
        "scope" => ["https =>//www.googleapis.com/auth/spreadsheets.readonly"],
        "access_type" => "offline",
        "expiry" => 60,
      }
      session["from_date"] = "1900-01-01"
      session["to_date"] = "1900-01-01"
    end
    it "succeeds when everything's in place" do
      class FakeSlugFetcher
        attr_accessor :slugs
        def initialize(_auth)
          @slugs = ["/"]
        end
      end
      class FakeFeedbackRequest
        attr_accessor :brexity_results
        def initialize(_from_date, _to_date, _slugs)
          @brexity_results = ["/"]
        end
      end
      class FakeFormatter
        attr_reader :formatted_results
        def initialize(_results)
          @formatted_results = [{
            "creation date": "date",
            "path": "path",
            "what doing?": "something",
            "what wrong": "other thing",
            "browser": "Opera",
            "browser version": "0.0.1",
            "browser platform": "DK",
            "user agent": "007",
            "referrer": "www.example.com",
          }]
        end
      end
      stub_const("Support::Requests::BrexitSlugFetcher", FakeSlugFetcher)
      stub_const("Support::Requests::BrexitFeedbackRequest", FakeFeedbackRequest)
      stub_const("Support::Requests::BrexitFeedbackFormatter", FakeFormatter)
      get :results
      expect(response).to have_http_status(200)
      session.delete("auth_client")
    end
    it "catches google errors appropriately" do
      class FakeSlugFetcher
        attr_accessor :slugs
        def initialize(_auth)
          raise Google::Apis::ClientError.new("error")
        end
      end
      stub_const("Support::Requests::BrexitSlugFetcher", FakeSlugFetcher)
      get :results
      expect(response).to have_http_status(403)
    end
  end
end
